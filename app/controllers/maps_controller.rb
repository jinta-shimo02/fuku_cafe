class MapsController < ApplicationController
  include MapConcern
  skip_before_action :authenticate_user!

  def home
    latitude = params[:latitude].to_f
    longitude = params[:longitude].to_f

    search_shops(latitude, longitude)

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

  private

  def search_shops(latitude, longitude)
    if params[:is_clothes_filter] == 'true'
      @clothes = circle_search(Clothes, latitude, longitude)
    elsif params[:is_cafe_filter] == 'true'
      @cafes = circle_search(Cafe, latitude, longitude)
    elsif params[:brand_name]
      brand = Brand.find_by(name: params[:brand_name])
      brand_shops = brand.shops
      @clothes = circle_search(brand.shops, latitude, longitude)
    else
      @clothes = circle_search(Clothes, latitude, longitude)
      @cafes = circle_search(Cafe, latitude, longitude)
    end
  end

  def circle_search(model, latitude, longitude)
    model.includes(:shop_images).within(1, origin: [latitude, longitude]).by_distance(origin: [latitude, longitude])
  end
end
