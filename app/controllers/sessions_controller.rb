class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = 'アカウントが有効化されていません。メールを確認してください。'
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'メールアドレスもしくはパスワードが違います'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def guest
    guest_user = User.find_by(email: 'guest@example.com')
    log_in guest_user
    redirect_to root_url
  end
end
