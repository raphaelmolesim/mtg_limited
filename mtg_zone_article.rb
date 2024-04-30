# rubocop:disable all

=begin

<h2 class="wp-block-heading">
    <span id="Grand_Abolisher">Grand Abolisher</span>
</h2>
<div class="cards-list centerme">
    <div class="simple-card-wrapper">
        <a target="_blank" href="https://mtgazone.com/cards/grand-abolisher/" class="cardblock">
            <div class="front">
                <img class="lazy" data-src="https://cards.scryfall.io/normal/front/1/4/1439551c-6764-4c35-a5ba-c7adb727cf7a.jpg?1712353251" alt="Grand Abolisher/" title="Grand Abolisher">
            </div>
        </a>
        ...
        <a target="_blank" href="https://mtgazone.com/cards/grand-abolisher/" class="cardbtn btn stripped">view card details</a>
    </div>
</div>
<h3 class="wp-block-heading">Rating: 1.5/5</h3>
<p>Just a dude. Unfortunately, it’s a hard to cast dude that mostly just shuts down counterspells.</p>

=end

class MtgZoneArticle

  def initialize(page)
    @page = page
  end

  def card_identifier
    "h2.wp-block-heading span"
  end

  def body
    @document ||= Nokogiri::HTML.parse(@page) 
  end 

  def cards
    body.css(card_identifier).select do |identifier_node|
      image_div = identifier_node.parent.next_element
      rating_h3 = image_div&.next_element
      comment_p = rating_h3&.next_element      
      next if [image_div, rating_h3, comment_p].any?(&:nil?)      
      identifier_node["id"].downcase == identifier_node.text.downcase.gsub(" ", "_") &&
       rating_h3.name == "h3" && comment_p.name == "p"
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
    matching_group = /Rating: ([0-5]\.[0.5])\/5/.match(text)
    return matching_group[1].to_f
  end

  def comment identifier_node
    comment = ""
    current_paragraph = identifier_node.parent.next_element.next_element.next_element
    current_paragraph.text
  end

end