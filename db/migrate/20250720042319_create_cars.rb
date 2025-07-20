class CreateCars < ActiveRecord::Migration[8.0]
  def change
    create_table :cars do |t|
      t.string :make
      t.string :model
      t.integer :year
      t.decimal :price
      t.text :description

      t.timestamps
    end
  end
end
