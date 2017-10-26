class Board < ApplicationRecord
  has_many :board_enrollments
  has_many :users, through: :board_enrollments
  has_many :lists, class_name: :List, foreign_key: :board_id
  has_one :leader, class_name: :User, foreign_key: :leader_id
end
