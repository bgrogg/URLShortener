class ShortenedUrl < ActiveRecord::Base
  validates :long_url, :short_url, presence: true, uniqueness: true, length: { maximum: 1024 }
  validates :user_id, presence: true

  def self.random_code
    rand_code = SecureRandom.urlsafe_base64[0...16]
    while ShortenedUrl.exists?(:short_url => rand_code)
      rand_code = SecureRandom.urlsafe_base64[0...16]
    end
    rand_code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(
      long_url: long_url,
      short_url: ShortenedUrl.random_code,
      user_id: user.id
    )
  end

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: "User"

  has_many :visits,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: "Visit"

  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :user

  def num_clicks
    Visit.where("shortened_url_id = ?", self.id).count
  end

  def num_uniques
    # Visit.select("DISTINCT user_id").where("shortened_url_id = ?", self.id).count
    self.visitors.length
  end

  def num_recent_uniques
    Visit.select("DISTINCT user_id").where("shortened_url_id = ? AND created_at > ?", self.id, 10.minutes.ago).count
  end

end
