require './shared/web'
require 'json'
require_relative './channel_fireball_article'

class ChannelFireballIndex
  URL = "https://cfb-infinite-api.tcgplayer.com/content/articles/search/?"

  def initialize(string = "limited set review")
    @query_string = {
      "source" => "cfb-infinite-content",
      "contentType" => "article",
      "rows" => 48,
      "search" => URI.encode_www_form_component(string)
    }
  end

  def url
    URL + @query_string.map { |k, v| "#{k}=#{v}" }.join("&")
  end

  def get_articles
    response = JSON(Web.get(url))
    response["result"]
  end

  def self.read_article article
    canonical_url = article["canonicalURL"]
    guid = canonical_url.split("/").last
    response = Web.get("https://cfb-infinite-api.tcgplayer.com/content/article/#{guid}/?source=cfb-infinite-content")
    ChannelFirebalArticle.new(response)
  end

  def self.save(cards:, set_abbreviation:)
    provider = "cfb"
    file_name = "#{set_abbreviation.downcase}_#{provider}.json"
    return false if File.exist?(file_name)
    File.open("db/#{file_name}", "w") { |f| f.write(cards.to_json) }
    true
  end

end