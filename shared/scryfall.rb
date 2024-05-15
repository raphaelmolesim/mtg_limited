require_relative "web"
require "json"

class Scryfall
  def sets
    response = Web.get("https://api.scryfall.com/sets")
    JSON.parse(response)["data"]
  end

  def last_released_sets
    sets.select { |set| set["set_type"] != "token" }.sort_by { |set| set["released_at"] }
      .reverse[0..10].map { |set| Set.new(set) }
  end

  def get_set(set_code)
    response = Web.get("https://api.scryfall.com/sets/#{set_code}")
    Set.new(JSON.parse(response))
  end

  def get_cards(set)
    cards = []
    response = JSON(Web.get("https://api.scryfall.com/cards/search?q=e:#{set.code}"))
    loop do
      cards << response["data"]
      break if !response["has_more"]
      response = JSON(Web.get(response["next_page"]))
    end
    cards.flatten
  end

  def get_block(set_code)
    raise "Set code is required" if set_code.nil?
    exclude_list = ["memorabilia", "promo", "commander", "promo", "token", "alchemy"]
    sets.select { |set|
      set["code"] == set_code ||
        (set["parent_set_code"]&.downcase == set_code && !exclude_list.include?(set["set_type"]))
    }.map { |set| Set.new(set) }
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
