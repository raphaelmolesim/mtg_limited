require 'sinatra'
require 'json'
require './scryfall'

set :port, 3001

get '/sets' do
  cards_files = Dir["./db/*-cards.json"]
  scryfall = Scryfall.new
  sets = cards_files.map { |file| file.split("/").last.split("-").first }
  sets = sets.map { |set| scryfall.get_set(set).to_json }
  sets.to_json
end