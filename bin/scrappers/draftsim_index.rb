require './shared/web'
require_relative './draftsim_article'

class DraftsimIndex
  URL = "https://duckduckgo.com/?"

  def initialize(string = "limited set review")
    @search_str = string
    @query_string = {
      "q" => "!ducky+" + URI.encode_www_form_component(string)
    }
  end

  def url
    URL + @query_string.map { |k, v| "#{k}=#{v}" }.join("&")
  end

  def get_articles
    duckduckgo_redirect = Web.get(url)
    location = duckduckgo_redirect.split('function ffredirect(){window.location.replace(\'').last.split('\');}setTimeout').first
    decoded_location = URI.decode_www_form_component(location)
    final_location = decoded_location.split("uddg=").last.split("&rut=").first
    [ { "title" => "Draftsim Article: #{@search_str}", "url" => final_location } ]
  end

  def self.read_article article
    response = Web.get(article["url"])
    DraftsimlArticle.new(response)
  end

  def self.save(cards:, set_abbreviation:)
    provider = "dfs"
    file_name = "#{set_abbreviation.downcase}_#{provider}.json"
    return false if File.exist?(file_name)
    File.open("db/#{file_name}", "w") { |f| f.write(cards.to_json) }
    true
  end

end