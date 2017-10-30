class AddTypeToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :type, :string
  end
end
