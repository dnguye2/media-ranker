class VotesController < ApplicationController
  def create
    @current_user = User.find_by(id: session[:user_id])
    user_id = @current_user.id
    vote = Vote.new(user_id: user_id, work_id: params[:work_id])

    if vote.save
      flash[:success] = "Succesfully upvoted!"
      redirect_to works_path
    else
      flash[:error] = "Could not upvote."
    end
  end




  private
  def vote_params
    params.permit(:user_id, :work_id)
  end
end
