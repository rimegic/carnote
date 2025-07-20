class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }

  def read?
    read_at.present?
  end

  def unread?
    !read?
  end

  def target_url
    case notifiable_type
    when 'Car'
      Rails.application.routes.url_helpers.car_path(notifiable)
    when 'Message'
      Rails.application.routes.url_helpers.conversation_path(notifiable.conversation)
    when 'Review'
      Rails.application.routes.url_helpers.car_path(notifiable.car)
    else
      Rails.application.routes.url_helpers.root_path
    end
  end
end