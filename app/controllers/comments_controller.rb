class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.micropost_id = params[:micropost_id]
    if @comment.save
      flash[:success] = "コメントを投稿しました"
      redirect_to @comment.micropost
    else
      @micropost = Micropost.find(params[:micropost_id])
      @comments = @micropost.comments
      render 'microposts/show'
    end
  end

  def destroy

  end

  private

    def comment_params
      params.require(:comment).permit(:content)
    end
end
