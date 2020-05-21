class WorksController < ApplicationController
  before_action :find_work, only: [:show, :update, :edit, :destroy]

  def index
    @works = Work.all
    @albums = Work.sorted_media("album")
    @books = Work.sorted_media("book")
    @movies = Work.sorted_media("movie")
  end

  def show
    if @work.nil?
      flash[:error] = "Work has either been deleted or not found."
      redirect_to root_path
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
    if @work.nil?
      head :not_found
      return
    elsif @work.update(work_params)
      redirect_to works_path(@work)
      return
    else
      render :edit
      return
    end
  end

  def edit
    if @work.nil?
      redirect_to works_path(@work)
      return
    end
  end

  def destroy
    if @work.nil?
      redirect_to works_path
      return
    end

    @work.destroy

    redirect_to works_path
    return
  end


  private
  def find_work
    @work = Work.find_by(id: params[:id])
  end

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end
end
