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
    return spotlight_media = Work.order("votes_count DESC").first
  end

  def self.top_ten(category)
    return nil if (Work.all).empty?

    top_ten_list = Work.where(category: category).sort_by{|work| [-work.votes_count, work.title]}.first(10)
    return top_ten_list
  end

  def self.sorted_media(category)
    sorted_collection = Work.where(category: category).sort_by{|work| [-work.votes_count, work.title]}

    return sorted_collection
  end
end
