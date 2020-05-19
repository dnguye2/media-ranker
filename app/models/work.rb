class Work < ApplicationRecord

  # validations

  def self.spotlight
    work = Work.all
    
    random_work_id = rand(1..(work.last.id))

    spotlight_media = work.find(random_work_id)

    if spotlight_media
      return spotlight_media
    else
      return nil
    end
  end

  def self.top_ten(category)
    work = Work.all
    category_collection = work.where(category: category)
    top_ten = category_collection.sample(10)
  end
end
