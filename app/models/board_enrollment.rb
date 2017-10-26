class BoardEnrollment < ApplicationRecord
  belongs_to :board, foreign_key: :board_id
  belongs_to :user, foreign_key: :user_id
  validates_uniqueness_of :user_id, :scope => :board_id
end
