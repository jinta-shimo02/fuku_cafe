class ShopSavedListsController < ApplicationController
  before_action :set_list, only: %i[show]

  def index
    @shop_saved_lists = current_user.shop_saved_lists
  end

  def new
    @shop_saved_list = current_user.shop_saved_lists.build
  end

  def create
    @shop_saved_list = current_user.shop_saved_lists.build(list_params)
    if @shop_saved_list.save
      redirect_to shop_saved_lists_path
    else
      render :new
      
    end
  end

  def show; end

  private

  def list_params
    params.require(:shop_saved_list).permit(:name)
  end

  def set_list
    @shop_saved_list = ShopSavedList.find(params[:id])
  end
end
