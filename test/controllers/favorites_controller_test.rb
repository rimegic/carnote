require "test_helper"

class FavoritesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @car = cars(:one)
    sign_in @user
  end

  test "should get favorites index" do
    get favorites_url
    assert_response :success
  end

  test "should create favorite" do
    # 기존 favorite이 있다면 삭제
    existing_favorite = @user.favorites.find_by(car: @car)
    existing_favorite&.destroy

    assert_difference("Favorite.count") do
      post favorites_url, params: { car_id: @car.id }
    end
    assert_redirected_to @car
  end

  test "should destroy favorite" do
    @user.favorites.create(car: @car)
    assert_difference("Favorite.count", -1) do
      delete favorite_url(@car)
    end
    assert_redirected_to @car
  end
end
