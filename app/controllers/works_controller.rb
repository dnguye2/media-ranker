class WorksController < ApplicationController
  def index
    @works = Work.all
    @movies = Work.where(category: "movie")
    @albums = Work.where(category: "album")
    @books = Work.where(category: "book")
  end

  def show
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)
    if @work.id?
      redirect_to root_path
    else
      render :new
      return
    end
  end

  def update
  end

  def edit
  end

  def destroy
  end

  private
  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end
end
