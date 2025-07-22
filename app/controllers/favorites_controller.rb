class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favorite_cars = current_user.favorite_cars
  end

  def create
    @car = Car.find(params[:car_id])
    unless current_user.favorite_cars.include?(@car)
      current_user.favorites.create(car: @car)
      flash[:notice] = "관심 차량에 추가되었습니다."
    else
      flash[:alert] = "이미 관심 차량에 추가된 차량입니다."
    end
    redirect_to @car
  end

  def destroy
    @car = Car.find(params[:id])
    favorite = current_user.favorites.find_by(car_id: @car.id)
    if favorite
      favorite.destroy
      flash[:notice] = "관심 차량에서 삭제되었습니다."
    else
      flash[:alert] = "관심 차량에 없는 차량입니다."
    end
    redirect_to @car
  end
end
