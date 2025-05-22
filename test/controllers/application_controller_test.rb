require "test_helper"

# Create a test controller to test our methods
class TestController < ApplicationController
  def index
    render plain: "test"
  end
end

# Add a route for our test controller
Rails.application.routes.draw do
  get 'test', to: 'test#index'
  get 'test-page', to: 'test#index'
  root to: 'test#index'
end

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test "should track visit" do
    assert_difference('Visit.count') do
      get "/test"
    end
  end
  
  test "should get time based greeting" do
    # Test morning greeting (5 AM - 11:59 AM)
    travel_to Time.new(2025, 5, 22, 10, 0, 0) do
      get "/test"
      assert_includes response.body, "Good morning!"
    end
    
    # Test afternoon greeting (12 PM - 4:59 PM)
    travel_to Time.new(2025, 5, 22, 14, 0, 0) do
      get "/test"
      assert_includes response.body, "Good afternoon!"
    end
    
    # Test evening greeting (5 PM - 8:59 PM)
    travel_to Time.new(2025, 5, 22, 19, 0, 0) do
      get "/test"
      assert_includes response.body, "Good evening!"
    end
    
    # Test night greeting (9 PM - 4:59 AM)
    travel_to Time.new(2025, 5, 22, 23, 0, 0) do
      get "/test"
      assert_includes response.body, "Good night!"
    end
  end
  
  test "should display visit information" do
    # Create a previous visit
    ip_address = "127.0.0.1"
    Visit.create(ip_address: ip_address, path: "/about", visited_at: 5.minutes.ago)
    
    # Set the remote IP for the test request
    host! "localhost"
    get "/test", env: { "REMOTE_ADDR" => ip_address }
    
    # Check that the page displays visit information
    assert_includes response.body, "Last visited:"
    assert_includes response.body, "Total visits:"
    assert_includes response.body, "This page:"
  end
  
  test "should count total visits" do
    initial_count = Visit.count
    
    # Create some visits
    3.times do |i|
      Visit.create(ip_address: "127.0.0.#{i}", path: "/page#{i}", visited_at: Time.current)
    end
    
    get "/test"
    
    # The page should show the total visits
    assert_includes response.body, "Total visits: #{initial_count + 4}"
  end
  
  test "should count page visits" do
    path = "/test-page"
    
    # Create some visits to the same page
    2.times do |i|
      Visit.create(ip_address: "127.0.0.#{i}", path: path, visited_at: Time.current)
    end
    
    # Create a visit to a different page
    Visit.create(ip_address: "127.0.0.3", path: "/different-page", visited_at: Time.current)
    
    # Visit the test page
    get path
    
    # The page should show the correct page visit count (2 + 1 from this request)
    assert_includes response.body, "This page: 3"
  end
end
