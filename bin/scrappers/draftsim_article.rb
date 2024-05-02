# rubocop:disable all

=begin

<h3 class="wp-block-heading">
  <span id="Archangel_of_Tithes">Archangel of Tithes</span>
</h3>
<div class="card_gallery_wrapper">
  <a class="mtg-card-db-card single-card" href="https://tcgplayer.pxf.io/c/2226219/1830156/21018?subId1=card_img&amp;partnerpropertyid=1989897&amp;u=https%3A%2F%2Ftcgplayer.com%2Fsearch%2Fmagic%2Fproduct%3Fq=Archangel%20of%20Tithes" rel="nofollow" target="_blank">
    <img width="265" height="370" style="margin-bottom: 4px; border-radius:10px;" alt="Archangel of Tithes" src="data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20viewBox='0%200%20265%20370'%3E%3C/svg%3E" data-lazy-src="https://draftsim.com/wp-content/uploads/mtg-card-DB/cards/c/8/c853d04c-864b-491c-8c6f-72d2d4874d2f.jpg">
    <noscript>
      <img width="265" height="370" style="margin-bottom: 4px; border-radius:10px;" alt="Archangel of Tithes" src="https://draftsim.com/wp-content/uploads/mtg-card-DB/cards/c/8/c853d04c-864b-491c-8c6f-72d2d4874d2f.jpg">
    </noscript>
  </a>
</div>
<p>
  <strong>Rating: </strong>5/10
</p>
<p>
  This is such a weird reprint from <a href="https://draftsim.com/mtg-magic-origins/"><em>Magic Origins</em></a>. It’s not particularly good, it’s just annoying. If you get to play this <a href="https://draftsim.com/mtg-angel/">angel</a>, it’ll certainly make an impact, but a triple white casting cost for an annoyance that can be easily killed isn’t something I’m that excited by. It’s a strong <a href="https://draftsim.com/mtg-white-creatures/">white creature</a>, but it won’t be game-changing.
</p>

=end

require 'nokogiri'
require './shared/card'
require 'json'

class DraftsimlArticle

  def initialize(page)
    @page = page
  end

  def card_identifier
    "h3.wp-block-heading span"
  end

  def body
    @document ||= Nokogiri::HTML.parse(@page) 
  end 

  def cards
    body.css(card_identifier).select do |identifier_node|
      image_div = identifier_node.parent.next_element
      rating_p = image_div&.next_element
      comment_p = rating_p&.next_element      
      next if [image_div, rating_p, comment_p].any?(&:nil?)      
      identifier_node["id"].downcase == identifier_node.text.downcase.gsub(" ", "_") &&
       rating_p.name == "p" && comment_p.name == "p"
    end.map do |identifier_node|
      Card.new(**({
        name: name(identifier_node),
        rating: rating(identifier_node),
        comment: comment(identifier_node)
      }))
    end
  end

  def name identifier_node
    identifier_node.text
  end

  def rating identifier_node
    text = identifier_node.parent.next_element.next_element.text
    matching_group = /Rating: ([0-9]+)\/10/.match(text)
    draftsim_rating = matching_group[1].to_f
    draftsim_rating / 2.0
  end

  def comment identifier_node
    identifier_node.parent.next_element.next_element.next_element.text
  end

end
