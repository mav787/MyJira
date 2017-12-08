class Comment < ApplicationRecord
  belongs_to :card, foreign_key: :card_id
  belongs_to :from_user, class_name: :User, foreign_key: :from_user_id
  belongs_to :to_user, class_name: :User, foreign_key: :to_user_id, optional:true
end
