# rubocop:disable all

=begin

<p>
  <card-spotlight card-id="Collector's Cage" card-vertical="magic" data-embed="card-spotlight">
  </card-spotlight>
</p>
<p class="text-align-center">
  <strong>
    Limited: 
  </strong>
  5.0
</p>
<p>
  Collector's Cage is a low-cost way to continuously grow the size of your team. You can accumulate value with every turn that passes, and the fact that you can add counters at instant speed makes combat a nightmare for the opponent.
</p>
<p>
  That alone would be in borderline bomb range, probably earning something close to a 4.0. On top of it, you get hideaway 5 with an easy-to-achieve mission for casting a free spell. Imagine a bomb that comes along with casting the best spell from your top five cards at the same time. If that's not slamming the door on the opponent, I don't know what is.
</p>
<hr>

=end

require 'nokogiri'
require './card'
require 'json'

class ChannelFirebalArticle

  def initialize(json_data)
    @json_data = JSON(json_data)
  end

  def card_identifier
    "card-spotlight"
  end

  def body
    @json_data["result"]["article"]["body"]
  end 

  def cards
    Nokogiri::HTML.parse(body).css(card_identifier).map do |identifier_node|
      Card.new(**({
        name: name(identifier_node),
        rating: rating(identifier_node),
        comment: comment(identifier_node)
      }))
    end
  end

  def name identifier_node
    identifier_node["card-id"]
  end

  def rating identifier_node
    text = identifier_node.parent.next_element.text
    /Limited: ([0-5]\.[0.5])/.match(text)[1].to_f
  end

  def comment identifier_node
    comment = ""
    current_paragraph = identifier_node.parent.next_element.next_element
    loop do
      comment += current_paragraph&.text || ""
      break if current_paragraph.nil? || current_paragraph.to_html.include?("<hr>")
      current_paragraph = current_paragraph.next_element
    end
    comment
  end

end
