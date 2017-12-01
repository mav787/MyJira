class AddStartDateToCard < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :startdate, :datetime

  end
end
