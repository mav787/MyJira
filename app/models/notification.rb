class Notification < ApplicationRecord
  belongs_to :recipient, :class_name => "User", :foreign_key => 'recipient_id'
  belongs_to :card, optional: true
  belongs_to :comment, optional: true
  belongs_to :board, optional: true
  scope :unread, ->{where read: false}
end
