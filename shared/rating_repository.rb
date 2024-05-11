class RatingRepository
  def self.get_open_rating_series(user_id:, set:)
    collection = client[:rating_series]
    query = {user_id:, set:, status: :open}
    series = collection.find(query)
    raise "More than one open rating series found" if series.count > 1
    series.first
  end

  def self.create_rating_series rating_series
    db = client.database
    db.collection("rating_series").insert_one(rating_series.to_h)
  end

  def self.create_rating rating
    collection = client[:ratings]
    collection.insert_one(rating.to_h)
  end

  def self.get_ratings_by_series_id(series_id)
    collection = client[:ratings]
    query = {rating_series_id: series_id}
    collection.find(query).to_a
  end

  def self.get_rating_series_by_id(id:, user_id:, set:)
    bson_id = BSON::ObjectId(id)
    collection = client[:rating_series]
    query = {user_id:, set:, _id: bson_id}
    puts "Query: #{query}"
    series = collection.find(query).first
    raise "Series not found" if series.nil?
    series
  end

  def self.close_rating_series(series_id)
    collection = client[:rating_series]
    query = {_id: BSON::ObjectId(series_id)}
    update = {"$set" => {status: :closed}}
    collection.update_one(query, update)
  end

  private

  def self.client
    Mongo::Client.new(ENV["MONGODB_CONNECTION_STRING"])
  end
end
