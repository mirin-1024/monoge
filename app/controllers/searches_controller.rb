class SearchesController < ApplicationController
  def search
    @search_model = params[:model]
    @search_word = params[:keyword]
    @search_results = search_for(@search_model, @search_word)
    render 'searches/search'
  end

  private

    def search_for(model, keyword)
      case model
      when 'User'
        User.where('name LIKE ?', "%#{keyword}%").paginate(page: params[:page])
      when 'Micropost'
        Micropost.where('content LIKE ?', "%#{keyword}%").paginate(page: params[:page])
      end
    end
end
