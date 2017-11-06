class AddCardOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :card_order, :integer
  end
end
