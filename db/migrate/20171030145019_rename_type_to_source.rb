class RenameTypeToSource < ActiveRecord::Migration[5.1]
  def change
    rename_column :notifications, :type, :source
  end
end
