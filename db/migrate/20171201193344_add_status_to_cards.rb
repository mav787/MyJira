class AddStatusToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :status, :integer
  end
end
