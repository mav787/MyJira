class CardEnrollment < ApplicationRecord
  belongs_to :card, foreign_key: :card_id
  belongs_to :user, foreign_key: :user_id
end
