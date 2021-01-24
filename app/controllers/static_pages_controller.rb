class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @post = current_user.posts.build
    @posts = current_user.feed.paginate(page: params[:page])
  end

  def contact
  end
end
