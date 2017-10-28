class NotificationsController < ApplicationController
  def index
    @notifications = Notification.where(recipient: current_user)
  end

  def mark_as read
    @notifications = Notification.where(recipient: current).unread
    @notifications.update.all(read: true)
    render json: {success: true}
  end
end
