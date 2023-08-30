class ShopsController < ApplicationController
  def show
    @shop = Shop.find(params[:id])
    @shop_images = @shop.shop_images
  end
end
