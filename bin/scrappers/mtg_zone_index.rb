require_relative "./mtg_zone_article"

class MtgZoneIndex
  URL = "https://mtgazone.com/?"

  def initialize(string = "limited set review")
    @query_string = {
      "s" => URI.encode_www_form_component(string),
      "ct_post_type" => "post%3Apage%3Ametagame%3Adeck%3Aspoilers"
    }
  end

  def url
    URL + @query_string.map { |k, v| "#{k}=#{v}" }.join("&")
  end

  def get_articles
    response = Web.get(url)
    Nokogiri::HTML.parse(response).css("article.entry-card").map do |article|
      {
        "title" => article.css("h2.entry-title a").text,
        "url" => article.css("h2.entry-title a").attr("href").value
      }
    end
  end

  def self.read_article article
    page = Web.get(article["url"])
    MtgZoneArticle.new(page)
  end

  def self.save(cards:, set_abbreviation:)
    provider = "zon"
    file_name = "#{set_abbreviation.downcase}_#{provider}.json"
    return false if File.exist?(file_name)
    File.write("db/#{file_name}", cards.to_json)
    true
  end
end
