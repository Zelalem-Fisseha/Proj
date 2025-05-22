require "test_helper"

class VisitTest < ActiveSupport::TestCase
  test "should not save visit without ip_address" do
    visit = Visit.new(path: "/home", visited_at: Time.current)
    assert_not visit.save, "Saved the visit without an ip_address"
  end
  
  test "should not save visit without path" do
    visit = Visit.new(ip_address: "127.0.0.1", visited_at: Time.current)
    assert_not visit.save, "Saved the visit without a path"
  end
  
  test "should not save visit without visited_at" do
    visit = Visit.new(ip_address: "127.0.0.1", path: "/home")
    assert_not visit.save, "Saved the visit without a visited_at timestamp"
  end
  
  test "should save valid visit" do
    visit = Visit.new(ip_address: "127.0.0.1", path: "/home", visited_at: Time.current)
    assert visit.save, "Could not save a valid visit"
  end
  
  test "should return last visit by ip" do
    ip = "192.168.1.1"
    older_time = 2.hours.ago
    newer_time = 1.hour.ago
    
    Visit.create(ip_address: ip, path: "/about", visited_at: older_time)
    newest_visit = Visit.create(ip_address: ip, path: "/contact", visited_at: newer_time)
    
    assert_equal newest_visit, Visit.last_visit_by_ip(ip)
  end
  
  test "should count total visits" do
    initial_count = Visit.total_count
    
    Visit.create(ip_address: "127.0.0.1", path: "/home", visited_at: Time.current)
    Visit.create(ip_address: "127.0.0.2", path: "/about", visited_at: Time.current)
    
    assert_equal initial_count + 2, Visit.total_count
  end
  
  test "should count page visits" do
    path = "/special-page"
    initial_count = Visit.page_count(path)
    
    Visit.create(ip_address: "127.0.0.1", path: path, visited_at: Time.current)
    Visit.create(ip_address: "127.0.0.2", path: path, visited_at: Time.current)
    Visit.create(ip_address: "127.0.0.3", path: "/different-page", visited_at: Time.current)
    
    assert_equal initial_count + 2, Visit.page_count(path)
  end
  
  test "should format time ago in words" do
    # Test seconds ago
    visit = Visit.create(ip_address: "127.0.0.1", path: "/home", visited_at: 30.seconds.ago)
    assert_match /30 seconds ago/, visit.time_ago_in_words
    
    # Test minutes ago
    visit = Visit.create(ip_address: "127.0.0.1", path: "/home", visited_at: 5.minutes.ago)
    assert_match /5 minutes ago/, visit.time_ago_in_words
    
    # Test hours ago
    visit = Visit.create(ip_address: "127.0.0.1", path: "/home", visited_at: 2.hours.ago)
    assert_match /2 hours ago/, visit.time_ago_in_words
    
    # Test days ago
    visit = Visit.create(ip_address: "127.0.0.1", path: "/home", visited_at: 3.days.ago)
    assert_match /3 days ago/, visit.time_ago_in_words
  end
end
