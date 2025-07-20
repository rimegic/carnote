class CarsController < ApplicationController
  include PaginationConcern
  
  before_action :set_car, only: [:show]

  def index
    @q = Car.includes(:user, :reviews, images_attachments: :blob).ransack(params[:q])
    cars_query = @q.result(distinct: true).order(created_at: :desc)
    
    pagination_data = paginate_collection(cars_query, per_page: 12)
    @cars = pagination_data[:collection]
    @pagination = pagination_data.except(:collection)
  end

  def show
    @reviews = @car.reviews.includes(:user).order(created_at: :desc)
    @new_review = Review.new
  end

  private

  def set_car
    @car = Car.find(params[:id])
  end
end