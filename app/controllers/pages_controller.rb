class PagesController < ApplicationController
  def index
    @top_albums = Work.top_ten("album")
    @top_books = Work.top_ten("book")
    @top_movies = Work.top_ten("movie")
    @spotlight = Work.spotlight()
  end
end
