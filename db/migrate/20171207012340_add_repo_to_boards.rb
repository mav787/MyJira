class AddRepoToBoards < ActiveRecord::Migration[5.1]
  def change
    add_column :boards, :repo, :string
  end
end
