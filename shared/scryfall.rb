require_relative "./web"
require "json"

class Scryfall
  def last_released_sets
    response = Web.get("https://api.scryfall.com/sets")
    sets = JSON.parse(response)["data"]
    sets.select { |set| set["set_type"] == "expansion" }.sort_by { |set| set["released_at"] }
      .reverse[0..10].map { |set| Set.new(set) }
  end

  def get_set(set_code)
    response = Web.get("https://api.scryfall.com/sets/#{set_code}")
    Set.new(JSON.parse(response))
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

    def to_json
      {
        "name" => @set["name"],
        "code" => @set["code"],
        "released_at" => @set["released_at"],
        "set_type" => @set["set_type"],
        "parent_set_code" => @set["parent_set_code"],
        "icon_svg_uri" => @set["icon_svg_uri"]
      }.to_json
    end

    def method_missing(method_name, *args, &block)
      @set[method_name.to_s]
    end
  end
end
