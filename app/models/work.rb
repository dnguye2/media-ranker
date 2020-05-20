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
    work = Work.all

    spotlight_media = work.sample(1)

    if !spotlight_media.nil?
      return spotlight_media[0]
    else
      return nil
    end
  end

  def self.top_ten(category)
    work = Work.all
    category_collection = work.where(category: category)
    top_ten = category_collection.sample(10)

    if top_ten.empty?
      return nil
    else
      return top_ten
    end
  end
end
