class CardEnrollment < ApplicationRecord
  belongs_to :card, foreign_key: :card_id
  belongs_to :user, foreign_key: :user_id
  validates_uniqueness_of :user_id, :scope => :card_id
end
