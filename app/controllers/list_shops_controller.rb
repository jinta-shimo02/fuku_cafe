class ListShopsController < ApplicationController
  def create
    @shop_saved_list = ShopSavedList.find(params[:list_id])
    @shop = Shop.find(params[:shop_id])
    @list_shop = @shop_saved_list.list_shops.build(shop: @shop)

    if @list_shop.save
      render json: { success: true, name: @list_shop.shop_saved_list.name }
    else
      render json: { sucess: false, errors: @list_shop.errors.full_messages }
    end
  end
  
  def destroy; end
end
