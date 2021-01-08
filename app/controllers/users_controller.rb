class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, except: [:show, :index, :new, :create]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome to the Alpha Blog #{@user.username}. Successfully singed up!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit 
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your account information was successfully updated"
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil
    flash[:notice] = "Account and its contents successfully deleted"
    redirect_to articles_path
  end

  private
   
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user
      flash[:alert] = "You can only edit or delete your own user profile"
      redirect_to @user
    end
  end
end
