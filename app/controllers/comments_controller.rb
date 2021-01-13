class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create]
  before_action :correct_user, only: [:destroy]

  def create
    @micropost = Micropost.find(params[:comment][:micropost_id])
    @comment = Comment.new(comment_params)
    if @comment.save
      @comments = @micropost.comments
      # flash[:success] = "コメントを作成しました"
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_url) }
        format.js
      end
    else
      @comments = @micropost.comments
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_url) }
        format.js
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @micropost = @comment.micropost
    @comment.destroy
    @comments = @micropost.comments
    # flash[:success] = "コメントを削除しました"
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:user_id, :micropost_id, :content)
    end

    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to root_url if @comment.nil?
    end
end
