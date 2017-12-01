class Tag < ApplicationRecord
  has_many :card_tag_associations
  has_many :cards, through: :card_tag_associations
  belongs_to :boards
end
