class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notifiable, polymorphic: true, null: false
      t.string :title, null: false
      t.text :message
      t.string :notification_type
      t.datetime :read_at
      t.timestamps
    end

    add_index :notifications, [ :user_id, :read_at ]
    add_index :notifications, [ :notifiable_type, :notifiable_id ]
    add_index :notifications, :created_at
  end
end
