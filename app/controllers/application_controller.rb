class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  before_action :track_visit
  helper_method :last_visit_time, :total_visits, :page_visits, :time_based_greeting
  
  private
  
  def track_visit
    # Create a new visit record
    Visit.create(
      ip_address: request.remote_ip,
      path: request.path,
      visited_at: Time.current
    )
  end
  
  def last_visit_time
    last_visit = Visit.where(ip_address: request.remote_ip)
                      .where.not(path: request.path)
                      .order(visited_at: :desc)
                      .first
    
    last_visit&.time_ago_in_words || "First visit"
  end
  
  def total_visits
    Visit.total_count
  end
  
  def page_visits
    Visit.page_count(request.path)
  end
  
  def time_based_greeting
    current_hour = Time.current.hour
    
    case current_hour
    when 5..11
      "Good morning!"
    when 12..16
      "Good afternoon!"
    when 17..20
      "Good evening!"
    else
      "Good night!"
    end
  end
end
