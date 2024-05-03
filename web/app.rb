require "sinatra"
require "json"
require "./shared/scryfall"
require "./shared/web"

set :port, 3001

public_folder = __dir__ + '/public'
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
  set = scryfall.get_set(params[:id])
  Web.get(set.icon_svg_uri)
end

get "/" do
  File.read("web/views/index.html")
end

get "/style.css" do
  content_type :css
  File.read("web/views/style.css")
end

