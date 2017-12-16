class User < ApplicationRecord
  before_save { self.email = email.downcase }
  before_create :confirmation_token
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
  has_many :notifications, class_name: :Notification, foreign_key: :recipient_id


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|

      user.uid = auth.uid
      user.provider = auth.provider

      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.email = auth.info.email
      user.password = "123123"
      user.email_confirmed = true
      user.save!
    end
  end

  def self.to_csv
    attributes = %w{id name email created_at updated_at}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |user|
        csv << user.attributes.values_at(*attributes)
      end

    end
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end

  def self.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end



  private
    def confirmation_token
      if self.confirm_token.blank?
          self.confirm_token = SecureRandom.urlsafe_base64.to_s
      end
    end

end
