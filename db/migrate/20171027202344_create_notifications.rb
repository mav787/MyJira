class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer :recipient_id
      t.boolean :read
      t.integer :card_id

      t.timestamps
    end
  end
end
