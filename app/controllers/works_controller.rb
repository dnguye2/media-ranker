class WorksController < ApplicationController
  def index
    @works = Work.all
    @albums = Work.where(category: "album")
    @books = Work.where(category: "book")
    @movies = Work.where(category: "movie")
  end

  def show
    work_id = params[:id]
    @work = Work.find_by(id: work_id)
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
    @work = Work.find_by(id: params[:id])

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
    work_id = params[:id].to_i
    @work = Work.find_by(id: work_id)

    if @work.nil?
      redirect_to works_path(@work)
      return
    end
  end

  def destroy
    work_id = params[:id]
    @work = Work.find_by(id: work_id)

    if @work.nil?
      redirect_to works_path
      return
    end

    @work.destroy

    redirect_to works_path
    return
  end


  private

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end
end
