require "sinatra"
require "json"
require "./shared/scryfall"
require "./shared/web"
require "./shared/rating_series"
require "./shared/rating"
require "./shared/cards_repository"
require 'mongo'
require 'dotenv/load'

set :port, 10000
set :bind, "0.0.0.0"

public_folder = __dir__ + "/public"
set :public_folder, public_folder
puts "Public folder: #{public_folder}"

get "/api/sets" do
  cards_files = Dir["./db/*-cards.json"]
  scryfall = Scryfall.new
  sets = cards_files.map { |file| file.split("/").last.split("-").first }.select
  sets = sets.map { |set| scryfall.get_set(set) }
    .select { |set| set.parent_set_code.nil? }.map { |set| JSON set.to_json }
  sets.to_json
end

get "/api/sets/:id/icon" do
  scryfall = Scryfall.new
  set_code = params[:id].downcase
  set = scryfall.get_set(set_code)
  Web.get(set.icon_svg_uri)
end

get "/api/sets/:id/cards/sample" do
  set = params[:id].downcase

  scryfall = Scryfall.new
  sets = scryfall.get_block(set).map { |set| set.code.downcase }

  ratings = JSON(File.read("./db/#{set}_cfb.json")).map { |rating| JSON rating }

  cards = sets.map do |set|
    JSON(File.read("./db/#{set}-cards.json"))
  end.flatten

  selected_rating = ratings.sample
  card = cards.find { |card| card["name"].downcase == selected_rating["name"].downcase }
  raise "Card not found. Name: #{selected_rating['name']}" if card.nil?
  merged_card = card.merge(selected_rating)
  JSON(merged_card)
end

post "/api/rating_series" do
  request_data = JSON.parse(request.body.read)
  user_id = 1
  rating = RatingSeries.new(user_id: user_id, set: request_data["set"])
  db = Mongo::Client.new(ENV['MONGODB_CONNECTION_STRING']).database
  result = db.collection("rating_series").insert_one(rating.to_h)
  result.inserted_id.to_s
end

post "/api/rating_series/:id/ratings" do
  id = BSON::ObjectId(params[:id])
  request_data = JSON.parse(request.body.read)
  user_id = 1
  set = request_data["set"]
  client = Mongo::Client.new(ENV['MONGODB_CONNECTION_STRING'])
  collection = client[:rating_series]
  query = { user_id:, set:, :"_id" => id }
  series = collection.find(query).first
  raise "Series not found" if series.nil?
  card_id = request_data["card_id"]
  rating = request_data["rating"]
  available_ratings = [ :bomb, :impactful, :filler_a, :filler_b, :trap]
  raise "Invalid rating: #{available_ratings}" if !available_ratings.include?(rating.to_sym)
  raise "Card id is requred" if card_id.nil?
  rating_model = Rating.new(card_id:, rating:, rating_series_id: params[:id], set:)
  collection = client[:ratings]
  result = collection.insert_one(rating_model.to_h)
  result.inserted_id.to_s
end

get "/" do
  File.read("web/views/index.html")
end

get "/settings" do
  { 
    public_folder: public_folder,
    public: Dir["#{public_folder}/*"]
  }.to_json
end

get "/style.css" do
  content_type :css
  File.read("web/views/style.css")
end
