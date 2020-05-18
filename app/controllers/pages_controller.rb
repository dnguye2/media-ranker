class PagesController < ApplicationController
  def index
    @top_albums = Work.top_ten_albums()
    @top_books = Work.top_ten_books()
    @top_movies = Work.top_ten_movies()
    @spotlight = Work.spotlight()
  end
end
