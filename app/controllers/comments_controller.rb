class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create]
  before_action :correct_user, only: [:destroy]

  def create
    @micropost = Micropost.find(params[:comment][:micropost_id])
    @comment = Comment.new(comment_params)
    if @comment.save
      flash[:success] = "コメントを投稿しました"
      redirect_to @micropost
    else
      render 'microposts/show'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:success] = "コメントを削除しました"
    redirect_to @comment.micropost
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
