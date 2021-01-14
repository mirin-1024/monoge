class LikesController < ApplicationController
  before_action :logged_in_user

  def create
    @micropost = Micropost.find(params[:micropost_id])
    return if @micropost.like?(current_user)

    @micropost.like(current_user)
    @micropost.reload
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end
  end

  def destroy
    @micropost = Like.find(params[:id]).micropost
    return unless @micropost.like?(current_user)

    @micropost.unlike(current_user)
    @micropost.reload
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end
  end
end
