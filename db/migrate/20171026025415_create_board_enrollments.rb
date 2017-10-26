class CreateBoardEnrollments < ActiveRecord::Migration[5.1]
  def change
    create_table :board_enrollments do |t|
      t.integer :user_id
      t.integer :board_id
      t.integer :level

      t.timestamps
    end
  end
end
