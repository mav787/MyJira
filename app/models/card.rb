class Card < ApplicationRecord

  has_many :card_enrollments
  has_many :users, through: :card_enrollments
  has_many :prerequisites, class_name: :Prerequisite, foreign_key: :precard_id
  has_many :postrequisites, class_name: :Prerequisite, foreign_key: :card_id
  has_many :precards, through: :postrequisites, source: :precard
  has_many :postcards, through: :prerequisites, source: :postcard
  has_many :comments
  has_many :card_tag_associations
  has_many :tags, through: :card_tag_associations
  belongs_to :list, foreign_key: :list_id

  def self.search_cards name
    Card.all.select { |c| c.content.downcase.include?(name) }
  end

  def self.to_csv
    attributes = %w{list_id content deadline card_order startdate finished_at description created_at updated_at}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |card|
        csv << card.attributes.values_at(*attributes)
      end
    end
  end
end
