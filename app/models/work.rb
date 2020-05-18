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

  def self.top_ten_albums
    work = Work.all
    albums = work.where(category: "album")
    top_ten_albums = albums.sample(10)
  end

  def self.top_ten_books
    work = Work.all
    books = work.where(category: "book")
    top_ten_books = books.sample(10)
  end

  def self.top_ten_movies
    work = Work.all
    movies = work.where(category: "movie")
    top_ten_movies = movies.sample(10)
  end
end
