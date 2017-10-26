class Prerequisite < ApplicationRecord
  belongs_to :card2, class_name: :Card, foreign_key: :card_id
  belongs_to :card1, class_name: :Card, foreign:key: :precard_id
end
