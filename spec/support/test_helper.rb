module TestHelper
  # -- SessionsHelper --
  # 現在ログインしているユーザーを返す
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # ユーザーがログインしているかをtrue/falseで返す
  def is_logged_in?
    !current_user.nil?
  end
end
