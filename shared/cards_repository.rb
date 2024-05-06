require "./shared/scryfall"

class CardsRepository
  def self.find_card_by_name(set:, name:)
    cards, ratings = load_dbs(set: set)
    card = cards.find { |card| card["name"].downcase == name }
    rating = ratings.find { |rating| rating["name"].downcase == name }
    card.merge(rating)
  end

  def self.find_card_by_id(set:, id:)
    cards, ratings = load_dbs(set: set)
    card = cards.find { |card| card["id"] == id }
    rating = ratings.find { |rating| rating["name"] == card["name"] }
    card.merge(rating)
  end

  private
  def self.load_dbs(set:)
    scryfall = Scryfall.new
    sets = scryfall.get_block(set).map { |set| set.code.downcase }
    cards = sets.map do |set|
      JSON(File.read("./db/#{set}-cards.json"))
    end.flatten
    ratings = JSON(File.read("./db/#{set}_cfb.json")).map { |rating| JSON rating }
    [cards, ratings]
  end
end