class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.order(created_at: :desc).limit(20)
    # Mark notifications as read when viewed
    current_user.notifications.unread.update_all(read_at: Time.current)
  end

  def mark_as_read
    notification = current_user.notifications.find(params[:id])
    notification.update(read_at: Time.current)
    redirect_to notification.target_url
  end

  def mark_all_as_read
    current_user.notifications.unread.update_all(read_at: Time.current)
    redirect_back(fallback_location: notifications_path)
  end
end