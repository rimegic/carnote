class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_car

  def create
    @review = @car.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @car, notice: '리뷰가 성공적으로 작성되었습니다.'
    else
      redirect_to @car, alert: '리뷰 작성에 실패했습니다: ' + @review.errors.full_messages.to_sentence
    end
  end

  def destroy
    @review = @car.reviews.find(params[:id])
    if @review.user == current_user
      @review.destroy
      redirect_to @car, notice: '리뷰가 성공적으로 삭제되었습니다.'
    else
      redirect_to @car, alert: '리뷰를 삭제할 권한이 없습니다.'
    end
  end

  private

  def set_car
    @car = Car.find(params[:car_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
