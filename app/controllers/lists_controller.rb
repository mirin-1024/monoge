class ListsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user, only: :destroy

  def create
    @list = current_user.lists.build(list_params)
    @list.save
    redirect_to lists_url
  end

  def destroy
    @list.destroy
    redirect_to lists_url
  end

  def index
    @lists = current_user.lists
  end

  private

    def list_params
      params.require(:list).permit(:label, :content)
    end

    def correct_user
      @list = current_user.lists.find_by(id: params[:id])
      redirect_to root_url if @list.nil?
    end
end
