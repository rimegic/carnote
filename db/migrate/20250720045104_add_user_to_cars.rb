class AddUserToCars < ActiveRecord::Migration[8.0]
  def change
    add_reference :cars, :user, null: false, foreign_key: true
  end
end
