class ShopSavedListsController < ApplicationController
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

  private

  def list_params
    params.require(:shop_saved_list).permit(:name)
  end
end
