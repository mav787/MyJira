class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  has_many :card_enrollments
  has_many :cards, through: :card_enrollments
  has_many :board_enrollments
  has_many :boards, through: :board_enrollments
  has_many :givecomments, class_name: :Comment, foreign_key: :from_user_id
  has_many :getcomments, class_name: :Comment, foreign_key: :to_user_id

end
