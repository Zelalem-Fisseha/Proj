class Visit < ApplicationRecord
  validates :ip_address, presence: true
  validates :path, presence: true
  validates :visited_at, presence: true
  
  # User information validations
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  validates :age, numericality: { only_integer: true, greater_than: 0, less_than: 120 }, allow_blank: true
  validates :comment, length: { maximum: 500 }
  
  # Get the last visit by IP address
  def self.last_visit_by_ip(ip_address)
    where(ip_address: ip_address).order(visited_at: :desc).first
  end
  
  # Count total visits
  def self.total_count
    count
  end
  
  # Count visits for a specific page
  def self.page_count(path)
    where(path: path).count
  end
  
  # Format time since last visit
  def time_ago_in_words
    seconds_ago = (Time.current - visited_at).to_i
    
    case seconds_ago
    when 0..59
      "#{seconds_ago} seconds ago"
    when 60..3599
      minutes = seconds_ago / 60
      "#{minutes} #{minutes == 1 ? 'minute' : 'minutes'} ago"
    when 3600..86399
      hours = seconds_ago / 3600
      "#{hours} #{hours == 1 ? 'hour' : 'hours'} ago"
    else
      days = seconds_ago / 86400
      "#{days} #{days == 1 ? 'day' : 'days'} ago"
    end
  end
  
  # Format the visit time in a readable format
  def formatted_visit_time
    visited_at.strftime("%B %d, %Y at %I:%M %p")
  end
end
