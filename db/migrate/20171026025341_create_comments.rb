class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :context
      t.integer :from_user_id
      t.integer :card_id
      t.integer :to_user_id

      t.timestamps
    end
  end
end
