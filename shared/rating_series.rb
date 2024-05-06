class RatingSeries

  attr_accessor :user_id, :id, :series, :set

  def initialize(user_id:, set:)
    raise "User ID is required" if user_id.nil?
    raise "Set is required" if set.nil?
    @user_id = user_id
    @set = set
    @series = []
  end

  def to_h
    {
      user_id: user_id,
      set: set,
      series: series
    }
  end

end