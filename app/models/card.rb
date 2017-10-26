class Card < ApplicationRecord

  has_many :card_enrollments
  has_many :users, through: :card_enrollments
  has_many :pre1s, class_name: :Prerequisite, foreign_key: :precard_id
  has_many :pre2s, class_name: :Prerequisite, foreign_key: :card_id
  has_many :comments
  has_many :card_tag_associations
  has_many :tags, through: :card_tag_associations
  belongs_to :list, foreign_key: :list_id
end
