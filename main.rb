require "./channel_fireball_index"
require "./mtg_zone_index"
require "./draftsim_index"

set = "Outlaws of Thunder Junction".downcase
set_abbreviation = "OTJ"
search_string = "limited set review #{set}"

providers_availables = {
  "1) Channel Fireball" => ChannelFireballIndex,
  "2) MTG Zone" => MtgZoneIndex,
  "3) Draftsim" => DraftsimIndex
}

puts "==> Select the provider you want to use: "
providers_availables.each { |k, v| puts k }

input = gets.chomp

selected_provider = providers_availables.keys[input.to_i - 1]
provider_class = providers_availables[selected_provider]

articles = provider_class.new(search_string).get_articles

found_articles = articles.select do |article|
  search_string.split(" ").all? { |set| article["title"].downcase.include?(set) }
end

puts "==> Found #{found_articles.size} articles for #{set}"

found_articles.each_with_index { |article, i| puts " #{i + 1}) #{article["title"]}" }

loop do
  puts "==> Read all articles? (y/n) Or type exclude some articles (e)?"

  input = gets.chomp

  if input == "e"
    puts "==> Enter the number of the article you want to exclude: "
    input = gets.chomp
    found_articles.delete_at(input.to_i - 1)
    found_articles.each_with_index { |article, i| puts " #{i + 1}) #{article["title"]}" }
  end

  if input == "n"
    puts "==> No articles read. Exiting..."
    exit
  end

  all_cards = []
  if input == "y"
    found_articles.each do |article|
      puts "==> Processing article..."
      cards = provider_class.read_article(article).cards
      all_cards += cards.map { |card| card.to_json }
      puts "Processed #{cards.size} cards, summing up to #{all_cards.size} cards."
    end
    puts "==> Finished processing all articles."
    provider_class.save(cards: all_cards, set_abbreviation: set_abbreviation)
    exit
  end

  exit if input == "q"
end
