require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @car = cars(:one)
    @review = @car.reviews.create(user: @user, rating: 5, comment: "Great car!")
    sign_in @user
  end

  test "should create review" do
    sign_in users(:two) # different user
    assert_difference('Review.count') do
      post car_reviews_url(@car), params: { review: { rating: 4, comment: "Good car" } }
    end
    assert_redirected_to @car
  end

  test "should destroy own review" do
    assert_difference('Review.count', -1) do
      delete car_review_url(@car, @review)
    end
    assert_redirected_to @car
  end
end
