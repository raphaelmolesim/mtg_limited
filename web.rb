require 'open-uri'
require 'net/http'

class Web
  def self.get url
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    response.body
  end
end