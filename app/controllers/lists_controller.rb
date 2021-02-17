class ListsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy update]
  before_action :correct_user, only: :destroy

  def create
    @list = current_user.lists.build(list_params)
    @list.remote_image_url = params[:list][:img_url] if params[:list][:img_url]
    @list.save
    @lists = current_user.lists
    respond_to do |format|
      format.html { redirect_to list_feed_user_url(current_user) }
      format.js
    end
    @list = nil
  end

  def update
    @list = current_user.lists.find_by(id: params[:id])
    return unless @list.update(list_params)

    flash[:success] = '編集に成功しました'
    redirect_to list_feed_user_url(current_user)
  end

  def destroy
    @list.destroy
    respond_to do |format|
      format.html { redirect_to list_feed_user_url(current_user) }
      format.js
    end
  end

  def search
    return unless params[:keyword] && params[:genre_id]

    @search_results = RakutenWebService::Ichiba::Product.search(genreId: params[:genre_id], keyword: params[:keyword])
  end

  private

    def list_params
      params.require(:list).permit(:label, :content, :image, :profile, :img_url)
    end

    def correct_user
      @list = current_user.lists.find_by(id: params[:id])
      redirect_to root_url if @list.nil?
    end
end
