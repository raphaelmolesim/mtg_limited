require "sinatra"
require "json"
require "./shared/scryfall"
require "./shared/web"
require "./shared/rating_series"
require "./shared/rating"
require "./shared/cards_repository"
require "./shared/rating_repository"
require 'mongo'
if ENV['RACK_ENV'] != 'production'
  require 'dotenv/load'
  require 'debug'
end

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

  card = nil
  selected_rating = nil
  loop do
    selected_rating = ratings.sample
    card = cards.find { |card| card["name"].downcase == selected_rating["name"].downcase }

    break if card
    puts "==> Card not found. Name: #{selected_rating['name']}" 
  end
  merged_card = card.merge(selected_rating)
  JSON(merged_card)
end

get "/api/rating_series/:id/ratings" do
  id = params[:id]
  RatingRepository.get_ratings_by_series_id(id).to_json
end

get "/api/rating_series" do
  user_id = 1
  series = RatingRepository.get_all_rating_series(user_id:)
  series.each do |series|
    ratings = RatingRepository.get_ratings_by_series_id(series.id)
    series.series = ratings
  end
  content_type :json
  series.map { |series| series.to_h }.to_json
end

post "/api/rating_series" do
  request_data = JSON.parse(request.body.read)
  user_id = 1
  series = RatingRepository.get_open_rating_series(user_id:, set: request_data["set"])
  return series["_id"].to_s if series
  rating_series = RatingSeries.new(user_id: user_id, set: request_data["set"])
  result = RatingRepository.create_rating_series(rating_series)
  result.inserted_id.to_s
end

post "/api/rating_series/:id/ratings" do
  request_data = JSON.parse(request.body.read)
  user_id = 1
  scryfall = Scryfall.new
  set = scryfall.sets.select { |set| set["code"].downcase == request_data["set"].downcase }.first
  set = (set["parent_set_code"] ? set["parent_set_code"] : set["code"]).downcase
  puts "Request data: #{request_data} #{params}"
  rating_series = RatingRepository.get_rating_series_by_id(id: params["id"], user_id:, set:)
  puts "===> Rating series: #{rating_series}"
  raise "This series is closed" if rating_series["status"] == :closed
  card_id = request_data["card_id"]
  rating = request_data["rating"]
  available_ratings = [ :bomb, :impactful, :filler_a, :filler_b, :trap]
  raise "Invalid rating: #{available_ratings}" if !available_ratings.include?(rating.to_sym)
  raise "Card id is requred" if card_id.nil?
  rating_model = Rating.new(card_id:, rating:, rating_series_id: params["id"], set:)
  result = RatingRepository.create_rating(rating_model)
  renew_series = false
  if (RatingRepository.get_ratings_by_series_id(params["id"]).size == 20)
    RatingRepository.close_rating_series(params["id"])
    renew_series = true
  end
  content_type :json
  {
    rating_id: result.inserted_id.to_s,
    renew_series: renew_series
  }.to_json
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
