class CreateCardTagAssociations < ActiveRecord::Migration[5.1]
  def change
    create_table :card_tag_associations do |t|
      t.integer :card_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
