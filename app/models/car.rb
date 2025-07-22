class Car < ApplicationRecord
  include Cacheable

  belongs_to :user
  has_many_attached :images
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
  has_many :reviews, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    [ "color", "created_at", "description", "id", "make", "mileage", "model", "price", "updated_at", "year" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "favorites", "favorited_by_users", "reviews", "user" ]
  end

  def average_rating
    @average_rating ||= Rails.cache.fetch("car/#{id}/average_rating", expires_in: 1.hour) do
      reviews.average(:rating)&.round(1) || 0
    end
  end

  def reviews_count
    @reviews_count ||= Rails.cache.fetch("car/#{id}/reviews_count", expires_in: 1.hour) do
      reviews.count
    end
  end

  def display_name
    "#{make} #{model} (#{year})"
  end
end
