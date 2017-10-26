class CreatePrerequisites < ActiveRecord::Migration[5.1]
  def change
    create_table :prerequisites do |t|
      t.integer :card_id
      t.integer :precard_id

      t.timestamps
    end
  end
end
