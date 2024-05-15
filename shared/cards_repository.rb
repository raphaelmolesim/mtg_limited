require "./shared/scryfall"

class CardsRepository
  def self.find_card_by_name(set:, name:)
    begin
      cards, ratings = cached_load_dbs(set: set)
      card = cards.find { |card| card["name"].downcase == name }
      rating = ratings.find { |rating| rating["name"].downcase == name }
      card.merge(rating)
    rescue => e
      raise "Card not found: #{name} for set: #{set}. Stack trace: #{e} / #{e.backtrace}"
    end
  end

  def self.find_card_by_id(set:, id:)
    begin
      cards, ratings = cached_load_dbs(set: set)
      card = cards.find { |card| card["id"] == id }
      rating = ratings.find { |rating| rating["name"] == card["name"] }
      card.merge(rating)
    rescue => e
      raise "Card not found: #{id} for set: #{set}. Stack trace: #{e} / #{e.backtrace}"
    end
  end

  private_class_method
  def self.load_dbs(set:)
    scryfall = Scryfall.new
    sets = scryfall.get_block(set).map { |set| set.code.downcase }
    cards = sets.map do |set|
      raise "File not found for set #{set}" unless File.exist?("./db/#{set}-cards.json")
      JSON(File.read("./db/#{set}-cards.json"))
    end.flatten
    ratings = JSON(File.read("./db/#{set}_cfb.json")).map { |rating| JSON rating }
    [cards, ratings]
  end

  
  def self.cached_load_dbs(set:)
    if @sets_db.nil? || !@sets_db[set]
      cards, ratings = load_dbs(set: set)
      @sets_db ||= {}
      @sets_db[set] = [cards, ratings]
    else
      cards, ratings = @sets_db[set]
    end
    [cards, ratings]
  end
end
