class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :favorites, dependent: :destroy
  has_many :favorite_cars, through: :favorites, source: :car
  has_many :reviews, dependent: :destroy
  has_many :sent_conversations, class_name: "Conversation", foreign_key: "sender_id"
  has_many :received_conversations, class_name: "Conversation", foreign_key: "recipient_id"
  has_many :messages, dependent: :destroy
  has_many :cars, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :price_alerts, dependent: :destroy

  def conversations
    Conversation.where("sender_id = ? OR recipient_id = ?", id, id)
  end

  def unread_notifications_count
    notifications.unread.count
  end
end
