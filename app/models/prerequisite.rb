class Prerequisite < ApplicationRecord
  belongs_to :precard, :class_name => "Card", :foreign_key => 'precard_id'
  belongs_to :postcard, :class_name => "Card", :foreign_key => 'card_id'
end
