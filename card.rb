
class Card

  attr_accessor :name, :rating, :comment

  def initialize(name:, rating:, comment:)
    @name = name
    @rating = rating
    @comment = comment
  end

  def to_json
    {
      name: @name,
      rating: @rating,
      comment: @comment
    }.to_json
  end
end
