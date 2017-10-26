class CreateCards < ActiveRecord::Migration[5.1]
  def change
    create_table :cards do |t|
      t.integer :list_id
      t.string :content
      t.datetime :deadline

      t.timestamps
    end
  end
end
