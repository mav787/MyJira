class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :string
      t.string :owner_id
      t.string :integer

      t.timestamps
    end
  end
end
