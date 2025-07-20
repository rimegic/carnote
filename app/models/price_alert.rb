class PriceAlert < ApplicationRecord
  belongs_to :user
  belongs_to :car

  validates :target_price, presence: true, numericality: { greater_than: 0 }
  validates :user_id, uniqueness: { scope: :car_id }

  scope :active, -> { where(active: true) }

  def self.check_price_drops
    active.includes(:user, :car).find_each do |alert|
      if alert.car.price <= alert.target_price
        alert.trigger_notification
        alert.update(active: false, triggered_at: Time.current)
      end
    end
  end

  def trigger_notification
    Notification.create!(
      user: user,
      notifiable: car,
      title: "가격 알림: #{car.display_name}",
      message: "설정하신 목표 가격 ₩#{target_price.to_i}에 도달했습니다! 현재 가격: ₩#{car.price.to_i}",
      notification_type: 'price_alert'
    )
  end
end