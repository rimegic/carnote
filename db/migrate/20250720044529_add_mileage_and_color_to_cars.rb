class AddMileageAndColorToCars < ActiveRecord::Migration[8.0]
  def change
    add_column :cars, :mileage, :integer
    add_column :cars, :color, :string
  end
end
