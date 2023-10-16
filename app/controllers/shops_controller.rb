class ShopsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @shop = Shop.find(params[:id])
    @shop_images = @shop.shop_images
    @closest_shop = @shop.closest_shop(@shop.latitude, @shop.longitude)
    @reviews = @shop.reviews.includes(:user).order(created_at: :desc).page(params[:page]).per(3)
  end
end
