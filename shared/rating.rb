class Rating

  attr_accessor :card_id, :rating, :rating_series_id, :card

  def initialize(card_id:, rating:, rating_series_id:, set:)
    @card_id = card_id
    @rating = rating
    @rating_series_id = rating_series_id
    @set = set
  end

  def card
    @card ||= CardsRepository.find_card_by_id(set: @set, id: card_id)
  end

  def conclusion    
    card_rating = card["rating"]
    conclusion = {
      5.0 => "bomb",
      4.5 => "bomb",
      4.0 => "impactful",
      3.5 => "impactful",
      3.0 => "filler_a",
      2.5 => "filler_a",
      2.0 => "filler_b",
      1.5 => "filler_b",
      1.0 => "trap",
      0.5 => "trap",
      0.0 => "trap"
    }[card_rating] == rating    
    conclusion.to_s
  end

  def to_h(with_card: false)
    hash = {
      card_id: card_id,
      rating: rating,
      conclusion: conclusion,
      rating_series_id: rating_series_id
    }
    hash[:card] = card if with_card
    hash
  end

end