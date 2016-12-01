class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validate :limit_recent_submissions

  has_many :submitted_urls,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: "ShortenedUrl"

  has_many :visits,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: "Visit"

  has_many :visited_urls,
    Proc.new { distinct },
    through: :visits,
    source: :shortened_url


  def limit_recent_submissions
    num_recent_submissions = Visit.select("DISTINCT shortened_url_id").where("user_id = ? AND created_at > ?", self.id, 1.minute.ago).count
    if num_recent_submissions >= 5
      errors[:too_many_submissions] << "can't submit more than 5 URLs in one minute"
    end
  end


end
