class RemoveStatusFromCards < ActiveRecord::Migration[5.1]
  def change
    remove_column :cards, :status, :integer
  end
end
