class WorksController < ApplicationController
  def index
    @works = Work.all
    @albums = Work.where(category: "album")
    @books = Work.where(category: "book")
    @movies = Work.where(category: "movie")
  end

  def show
    work_id = params[:id]
    @work = Work.find_by(id: book_id)
    if @work.nil?
      head :not_found
      return
    end
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.create(work_params)
    if @work.id?
      redirect_to root_path
    else
      render :new
    end

    rescue ActionController::ParameterMissing
      redirect_to new_work_path
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
