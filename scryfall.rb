class Scryfall

  def last_released_sets
    response = Web.get("https://api.scryfall.com/sets")
    sets = JSON.parse(response)["data"]
    sets.select { |set| set["set_type"] == "expansion" }.sort_by { |set| set["released_at"] }
      .reverse[0..10].map { |set| Set.new(set) }
  end

  def get_cards(set)
    response = Web.get("https://api.scryfall.com/cards/search?q=e:#{set.code}")
    JSON.parse(response)["data"]
  end

  class Set

    def initialize(set)
      @set = set
    end

    def to_s
      "#{@set["name"]} - #{@set["code"].upcase}"
    end

    def method_missing(method_name, *args, &block)
      @set[method_name.to_s]
    end

  end


end