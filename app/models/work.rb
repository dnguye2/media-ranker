class Work < ApplicationRecord

  # Validations
  validates :title, presence: true
  validates :category, presence: true
  validates :creator, presence: true
  validates :publication_year, presence: true
  validates :description, presence: true

  # Relationships
  has_many :votes, dependent: :destroy
  has_many :users, :through => :votes

  # Methods
  def self.spotlight
    spotlight_media = Work.order("votes_count DESC").first
  end

  def self.top_ten(category)
    top_ten_list = Work.where(category: category).order("votes_count DESC").limit(10)
    return top_ten_list
  end

  def self.sorted_media(category)
    sorted_collection = Work.where(category: category).order("votes_count DESC")
    return sorted_collection
  end
end
