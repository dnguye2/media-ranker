class UsersController < ApplicationController
  def login_form
    @user = User.new
  end

  def login
    username = user_params[:username]
    @user = User.find_by(username: username)

    if @user
      session[:user_id] = @user.id
      flash[:success] = "Successfully logged in as returning user #{@user.username}"
      redirect_to root_path
    else
      @user = User.new(username: username)
      if @user.save
        session[:user_id] = @user.id
        flash[:success] = "Successfully logged in as new user #{@user.username}"
        redirect_to root_path
      else
        flash.now[:error] = "Unable to log in"
        render :login_form
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:success] = "Successfully logged out"
    redirect_to root_path
    return
  end

  def current
    @current_user = User.find_by(id: session[:user_id])
    unless @current_user
      flash[:error] = "You must be logged in to see this page"
      redirect_to root_path
      return
    end
  end

  def show
    user_id = params[:id]
    @user = User.find_by(id: user_id)
    if @user.nil?
      head :not_found
      return
    end
  end

  def index
    @users = User.all
  end

  private

  def user_params
    return params.require(:user).permit(:username)
  end
end
