class LikesController < ApplicationController
  before_action :logged_in_user

  def create
    @micropost = Micropost.find(params[:micropost_id])
    @micropost.like(current_user)
  end

  def destroy
    @micropost = Like.find(params[:id]).micropost
    @micropost.unlike(current_user)
  end
end
