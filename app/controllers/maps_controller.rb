class MapsController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    gon.latitude = 35.6813843233819
    gon.longitude = 139.76712479697295
    gon.api_key = ENV['API_KEY']
    gon.user_logged_in = user_signed_in?

    latitude = params[:latitude].to_f
    longitude = params[:longitude].to_f

    if params[:is_clothes_filter] == 'true'
      @clothes = Clothes.includes(:shop_images).within(1, origin: [latitude, longitude]).by_distance(origin: [latitude, longitude])
    elsif params[:is_cafe_filter] == 'true'
      @cafes = Cafe.includes(:shop_images).within(1, origin: [latitude, longitude]).by_distance(origin: [latitude, longitude])
    elsif params[:brand_name]
      brand = Brand.find_by(name: params[:brand_name])
      brand_shops = brand.shops
      @clothes = brand_shops.includes(:shop_images).within(1, origin: [latitude, longitude]).by_distance(origin: [latitude, longitude])
    else
      @clothes = Clothes.includes(:shop_images).within(1, origin: [latitude, longitude]).by_distance(origin: [latitude, longitude])
      @cafes = Cafe.includes(:shop_images).within(1, origin: [latitude, longitude]).by_distance(origin: [latitude, longitude])
    end

    respond_to do |format|
      format.html
      format.json do
        render json: {
          clothes: @clothes.as_json(include: :shop_images),
          cafes: @cafes.as_json(include: :shop_images)
        }
      end
    end
  end
end
