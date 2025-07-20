require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should show user profile" do
    get user_url
    assert_response :success
  end

  test "should get edit user profile" do
    get edit_user_url
    assert_response :success
  end

  test "should update user profile" do
    patch user_url, params: { user: { email: "newemail@example.com" } }
    assert_redirected_to user_url
  end
end
