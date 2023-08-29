class MapsController < ApplicationController
  def home
    gon.latitude = 35.6813843233819
    gon.longitude = 139.76712479697295
    gon.api_key = ENV['API_KEY']

    north = params[:north].to_f
    south = params[:south].to_f
    east = params[:east].to_f
    west = params[:west].to_f

    @clothes = Clothes.includes(:shop_images).where(latitude: south..north, longitude: west..east)
    @cafes = Cafe.includes(:shop_images).where(latitude: south..north, longitude: west..east)

    respond_to do |format|
      format.html
      format.json { render json: {
         clothes: @clothes.as_json(include: :shop_images),
         cafes: @cafes.as_json(include: :shop_images)
        } }
    end
  end
end
