class AddBoardIdToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :board_id, :integer
  end
end
