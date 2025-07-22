class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_user, only: [ :edit_user, :update_user, :destroy_user ]
  before_action :set_car, only: [ :edit_car, :update_car, :destroy_car ]

  def index
    @users = User.all
    @cars = Car.all
    @reviews = Review.all

    @total_users = User.count
    @total_cars = Car.count
    @total_reviews = Review.count
  end

  def edit_user
  end

  def update_user
    if @user.update(user_params)
      redirect_to admin_path, notice: "사용자 정보가 성공적으로 업데이트되었습니다."
    else
      render :edit_user
    end
  end

  def destroy_user
    @user.destroy
    redirect_to admin_path, notice: "사용자가 성공적으로 삭제되었습니다."
  end

  def new_car
    @car = Car.new
  end

  def create_car
    @car = Car.new(car_params)
    @car.user = current_user
    if @car.save
      redirect_to admin_path, notice: "차량이 성공적으로 추가되었습니다."
    else
      render :new_car
    end
  end

  def edit_car
  end

  def update_car
    if @car.update(car_params)
      redirect_to admin_path, notice: "차량 정보가 성공적으로 업데이트되었습니다."
    else
      render :edit_car
    end
  end

  def destroy_car
    @car.destroy
    redirect_to admin_path, notice: "차량이 성공적으로 삭제되었습니다."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    permitted_params = [ :email, :password, :password_confirmation ]
    # 관리자만 admin 권한을 변경할 수 있음
    permitted_params << :admin if current_user&.admin?
    params.require(:user).permit(permitted_params)
  end

  def set_car
    @car = Car.find(params[:id])
  end

  def car_params
    params.require(:car).permit(:make, :model, :year, :price, :description, :mileage, :color, images: [])
  end

  def ensure_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "관리자 권한이 필요합니다."
    end
  end
end
