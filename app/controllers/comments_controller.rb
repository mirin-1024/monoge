class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create]
  before_action :correct_user, only: [:destroy]

  def create
    @post = Post.find(params[:comment][:post_id])
    @comment = Comment.new(comment_params)
    @comment.save
    @comments = @post.comments
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @comment.destroy
    @comments = @post.comments
    flash[:success] = 'コメントを削除しました'
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:user_id, :post_id, :content)
    end

    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to root_url if @comment.nil?
    end
end
