require 'test_helper'

class FollowControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get follow_create_url
    assert_response :success
  end

end
