class Work < ApplicationRecord

  # Validations
  validates :title, presence: true
  validates :category, presence: true
  validates :creator, presence: true
  validates :publication_year, presence: true
  validates :description, presence: true

  # Relationships
  has_many :votes
  has_many :users, :through => :votes

  # Methods
  def self.spotlight
    works = Work.all

    works_hash = {}

    works.each do |work|
      works_hash[work.id] = work.votes.count
    end

    spotlight_id = works_hash.key(works_hash.values.max)
    spotlight_media = Work.find_by(id: spotlight_id)
  end

  def self.top_ten(category)
    work = Work.all
    category_collection = work.where(category: category)

    if category_collection.nil?
      return nil
    end

    works_hash = {}

    category_collection.each do |work|
      works_hash[work.id] = work.votes.count
    end
    
    # Getting top maximum ten values off of hash
    # source: https://stackoverflow.com/questions/24044646/how-to-pick-top-5-values-from-a-hash
    top_ten_ids = works_hash.sort_by { |_, v| -v }.first(10).map(&:first)

    top_ten = top_ten_ids.map do |id|
      Work.find_by(id: id)
    end

    return top_ten
  end
end
