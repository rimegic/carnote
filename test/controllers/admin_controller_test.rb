require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin_user = users(:two) # user with admin: true
    @regular_user = users(:one)
    sign_in @admin_user
  end

  test "should get admin index when logged in as admin" do
    get admin_url
    assert_response :success
  end

  test "should redirect when not admin" do
    sign_out @admin_user
    sign_in @regular_user
    get admin_url
    assert_response :redirect
  end
end
