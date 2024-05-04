require "sinatra"
require "json"
require "./shared/scryfall"
require "./shared/web"

set :port, 3001
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

get "/" do
  File.read("web/views/index.html")
end

get "/style.css" do
  content_type :css
  File.read("web/views/style.css")
end
