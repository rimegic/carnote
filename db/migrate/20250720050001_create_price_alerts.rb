class CreatePriceAlerts < ActiveRecord::Migration[8.0]
  def change
    create_table :price_alerts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :car, null: false, foreign_key: true
      t.decimal :target_price, precision: 10, scale: 2, null: false
      t.boolean :active, default: true
      t.datetime :triggered_at
      t.timestamps
    end

    add_index :price_alerts, [ :user_id, :car_id ], unique: true
    add_index :price_alerts, :active
  end
end
