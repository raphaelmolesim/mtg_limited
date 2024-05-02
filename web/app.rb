require "sinatra"
require "json"
require "./shared/scryfall"

set :port, 3001

public_folder = __dir__ + '/public'
set :public_folder, public_folder
puts "Public folder: #{public_folder}"

get "/sets" do
  cards_files = Dir["./db/*-cards.json"]
  scryfall = Scryfall.new
  sets = cards_files.map { |file| file.split("/").last.split("-").first }.select
  sets = sets.map { |set| scryfall.get_set(set) }
    .select { |set| set.parent_set_code.nil? }.map { |set| set.to_json }
  sets.to_json
end

get "/" do
  File.read("web/views/index.html")
end

get "/style.css" do
  content_type :css
  File.read("web/views/style.css")
end

