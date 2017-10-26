class List < ApplicationRecord
  belongs_to :board, foreign_key: :board_id
  has_many :cards, class_name: :Card, foreign_key: :list_id
end
