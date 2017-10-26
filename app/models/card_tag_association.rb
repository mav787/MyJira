class CardTagAssociation < ApplicationRecord
  belongs_to :card, foreign_key: :card_id
  belongs_to :tag, foreign_key: :tag_id
end
