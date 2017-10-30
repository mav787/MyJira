class AddTypeToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :type, :string
  end
end
