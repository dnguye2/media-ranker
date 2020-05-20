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
    # work = Work.all

    # spotlight_media = work.sample(1)

    # if !spotlight_media.nil?
    #   return spotlight_media[0]
    # else
    #   return nil
    # end

    works = Work.all

    # spotlight_media = work.max_by(votes)

    # if !spotlight_media.nil?
    #   return spotlight_media
    # else
    #   return nil
    # end

    # each work
    # key : work id
    # value = work.votes.count

    # use max_by to return id base off of highest value

    # spotlight media = find by id

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
    top_ten = category_collection.sample(10)

    if top_ten.empty?
      return nil
    else
      return top_ten
    end
  end
end
