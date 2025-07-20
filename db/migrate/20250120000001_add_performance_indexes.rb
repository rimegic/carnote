class AddPerformanceIndexes < ActiveRecord::Migration[8.0]
  def change
    # Cars table indexes for better search performance
    add_index :cars, :make
    add_index :cars, :model
    add_index :cars, :year
    add_index :cars, :price
    add_index :cars, :mileage
    add_index :cars, :color
    add_index :cars, [:make, :model]
    add_index :cars, [:year, :price]
    add_index :cars, :created_at
    
    # Reviews table indexes
    add_index :reviews, :rating
    add_index :reviews, :created_at
    add_index :reviews, [:car_id, :rating]
    
    # Favorites table composite index
    add_index :favorites, [:user_id, :car_id], unique: true
    
    # Messages table indexes
    add_index :messages, :created_at
    
    # Conversations table indexes
    add_index :conversations, [:sender_id, :recipient_id], unique: true
  end
end