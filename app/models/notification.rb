class Notification < ApplicationRecord
  belongs_to :recipient, :class_name => "User", :foreign_key => 'recipient_id'
  belongs_to :card
  belongs_to :comment
  scope :unread, ->{where read: false}
end
