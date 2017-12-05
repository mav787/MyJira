class Board < ApplicationRecord
  has_many :board_enrollments
  has_many :users, through: :board_enrollments
  has_many :lists, class_name: :List, foreign_key: :board_id
  belongs_to :leader, class_name: :User
  has_many :tags, class_name: :List, foreign_key: :board_id

  def self.to_csv
    attributes = %w{name leader_id created_at updated_at description}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |board|
        csv << board.attributes.values_at(*attributes)
      end
    end
  end
end
