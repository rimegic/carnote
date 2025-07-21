class AddPerformanceIndexes < ActiveRecord::Migration[8.0]
  def change
    # Cars table indexes for better search performance
    add_index :cars, :make
    add_index :cars, :model
    add_index :cars, :year
    add_index :cars, :price
    
    
    add_index :cars, [:make, :model]
    add_index :cars, [:year, :price]
    add_index :cars, :created_at
    
    # Reviews table indexes
    
    
    # Favorites table composite index
    
    
    # Messages table indexes
    
    
    # Conversations table indexes
    
  end
end