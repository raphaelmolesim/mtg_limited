class RatingSeries

  attr_accessor :user_id, :id, :series, :set, :status

  STATUS = [ :open, :closed ]

  def initialize(user_id:, set:)
    raise "User ID is required" if user_id.nil?
    raise "Set is required" if set.nil?
    @user_id = user_id
    @set = set
    @series = []
    @status = :open
  end

  def self.parse(hash)
    series = RatingSeries.new(user_id: hash["user_id"], set: hash["set"])
    series.id = hash["_id"].to_s
    series.status = hash["status"]
    series
  end

  def to_h
    {
      id: id,
      user_id: user_id,
      set: set,
      series: series,
      status: status
    }
  end

end