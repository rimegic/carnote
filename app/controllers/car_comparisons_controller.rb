class CarComparisonsController < ApplicationController
  def index
    @car_ids = session[:comparison_cars] || []
    @cars = Car.where(id: @car_ids).includes(:user, :reviews, images_attachments: :blob)
  end

  def add
    @car = Car.find(params[:car_id])
    session[:comparison_cars] ||= []

    unless session[:comparison_cars].include?(@car.id)
      if session[:comparison_cars].length < 3
        session[:comparison_cars] << @car.id
        flash[:notice] = "#{@car.make} #{@car.model}이(가) 비교 목록에 추가되었습니다."
      else
        flash[:alert] = "최대 3개의 차량만 비교할 수 있습니다."
      end
    else
      flash[:alert] = "이미 비교 목록에 있는 차량입니다."
    end

    redirect_back(fallback_location: cars_path)
  end

  def remove
    @car = Car.find(params[:car_id])
    session[:comparison_cars] ||= []
    session[:comparison_cars].delete(@car.id)

    flash[:notice] = "#{@car.make} #{@car.model}이(가) 비교 목록에서 제거되었습니다."
    redirect_back(fallback_location: car_comparisons_path)
  end

  def clear
    session[:comparison_cars] = []
    flash[:notice] = "비교 목록이 초기화되었습니다."
    redirect_to cars_path
  end
end
