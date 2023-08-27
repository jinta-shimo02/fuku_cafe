class MapsController < ApplicationController
  def home
    gon.latitude = 35.6813843233819
    gon.longitude = 139.76712479697295
  end

  def search
    north = params[:north].to_f
    south = params[:south].to_f
    east = params[:east].to_f
    west = params[:west].to_f

    @clothes = Clothes.where(latitude: south..north, longitude: west..east)
    @cafes = Cafe.where(latitude: south..north, longitude: west..east)

    render json: { clothes: @clothes, cafes: @cafes}
  end
end
