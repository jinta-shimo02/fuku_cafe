class ListShopsController < ApplicationController
  def create
    @shop_saved_list = ShopSavedList.find(params[:list_id])
    @shop = Shop.find(params[:shop_id])
    @list_shop = @shop_saved_list.list_shops.build(shop: @shop)

    if @list_shop.save
      render json: { success: true, name: @list_shop.shop_saved_list.name }
    else
      render json: { success: false, errors: @list_shop.errors.full_messages }
    end
  end

  def destroy
    shop_saved_list = current_user.shop_saved_lists.find_by(id: params[:id])
    shop = Shop.find(params[:shop_id])

    if shop_saved_list.shops.destroy(shop)
      redirect_to shop_saved_list_path(shop_saved_list), success: '削除しました'
    else
      flash.now[:error] = '削除に失敗しました'
      render template: 'shop_saved_list/show'
    end
  end
end
