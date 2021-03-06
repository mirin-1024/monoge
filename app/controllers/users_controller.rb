class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[index edit update destroy following followers]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: [:destroy]
  before_action :guest_user, only: %i[edit update]

  def new
    @user = User.new
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = '入力されたメールアドレスにアカウント有効化用のメールをお送りいたしました。確認をお願いします。'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = '編集に成功しました'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'ユーザーを削除しました'
    redirect_to users_url
  end

  def following
    @title = 'フォロー中'
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'フォロワー'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def list_feed
    @user = User.find(params[:id])
    @list = current_user.lists.build
    @lists = @user.lists.paginate(page: params[:page])
    render 'show_lists'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :image, :profile)
    end

    # 正しいユーザーであるか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def guest_user
      @user = User.find_by(email: Rails.application.credentials.guest[:email])
      flash[:danger] = 'ゲストユーザーでは制限されています'
      redirect_back_or root_url if current_user?(@user)
    end
end
