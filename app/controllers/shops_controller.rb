class ShopsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @shop = Shop.find(params[:id])
    @shop_images = @shop.shop_images
  end
end
