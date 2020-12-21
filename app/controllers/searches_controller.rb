class SearchesController < ApplicationController
  def search
    @model = params[:model]
    @keyword = params[:content]
    @search_results = search_for(@model, @keyword)
    redirect_to search_path
  end

private

  def search_for(model, keyword)
    if model == User
      User.where("name LIKE ?", "%#{keyword}%").paginate(page: params[:page])
    else model == Micropost
      Micropost.where("content LIKE ?", "%#{keyword}%").paginate(page: params[:page])
    end
  end
end
