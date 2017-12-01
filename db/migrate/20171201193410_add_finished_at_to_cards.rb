class AddFinishedAtToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :finished_at, :datetime
  end
end
