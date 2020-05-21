class VotesController < ApplicationController
  before_action :require_login, only: [:create]

  def create
    @current_user = User.find_by(id: session[:user_id])
    user_id = @current_user.id

    
    vote = Vote.new(user_id: user_id, work_id: params[:work_id])

    if Vote.where(user_id: @current_user.id, work_id: params[:work_id]).any?
      flash[:error] = "You've already upvoted this work."
      redirect_to works_path
      return
    end
    
    if vote.save
      flash[:success] = "Succesfully upvoted!"
      redirect_to works_path
      return
    else
      flash[:error] = "Could not upvote."
      redirect_to works_path
      return
    end
  end


  private
  def vote_params
    params.permit(:user_id, :work_id)
  end
end
