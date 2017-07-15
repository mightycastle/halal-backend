require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  test "should get by_location" do
    get :by_location
    assert_response :success
  end

end
