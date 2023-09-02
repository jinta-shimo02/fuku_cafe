class MapsController < ApplicationController
  skip_before_action :authenticate_user!
  
  def home
    gon.latitude = 35.6813843233819
    gon.longitude = 139.76712479697295
    gon.api_key = ENV['API_KEY']

    north = params[:north].to_f
    south = params[:south].to_f
    east = params[:east].to_f
    west = params[:west].to_f

    
    is_clothes_filter = params[:is_clothes_filter] == 'true'
    is_cafe_filter = params[:is_cafe_filter] == 'true'
    
    if params[:is_clothes_filter] == 'true'
      @clothes = Clothes.includes(:shop_images).where(latitude: south..north, longitude: west..east)
    elsif params[:is_cafe_filter] == 'true'
      @cafes = Cafe.includes(:shop_images).where(latitude: south..north, longitude: west..east)
    else
      @clothes = Clothes.includes(:shop_images).where(latitude: south..north, longitude: west..east)
      @cafes = Cafe.includes(:shop_images).where(latitude: south..north, longitude: west..east)
    end


    respond_to do |format|
      format.html
      format.json { render json: {
         clothes: @clothes.as_json(include: :shop_images),
         cafes: @cafes.as_json(include: :shop_images)
        } }
    end
  end
end
