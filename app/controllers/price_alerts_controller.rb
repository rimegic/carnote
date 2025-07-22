class PriceAlertsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_car, only: [ :create ]
  before_action :set_price_alert, only: [ :destroy ]

  def index
    @price_alerts = current_user.price_alerts.includes(:car).order(created_at: :desc)
  end

  def create
    @price_alert = current_user.price_alerts.build(price_alert_params)
    @price_alert.car = @car

    if @price_alert.save
      flash[:notice] = "가격 알림이 설정되었습니다. 목표 가격에 도달하면 알려드리겠습니다."
    else
      flash[:alert] = "가격 알림 설정에 실패했습니다: #{@price_alert.errors.full_messages.to_sentence}"
    end

    redirect_to @car
  end

  def destroy
    @price_alert.destroy
    flash[:notice] = "가격 알림이 삭제되었습니다."
    redirect_back(fallback_location: price_alerts_path)
  end

  private

  def set_car
    @car = Car.find(params[:car_id])
  end

  def set_price_alert
    @price_alert = current_user.price_alerts.find(params[:id])
  end

  def price_alert_params
    params.require(:price_alert).permit(:target_price)
  end
end
