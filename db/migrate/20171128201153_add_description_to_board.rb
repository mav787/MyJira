class AddDescriptionToBoard < ActiveRecord::Migration[5.1]
  def change
    add_column :boards, :description, :string
  end
end
