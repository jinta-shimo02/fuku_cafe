class MapsController < ApplicationController
  def home
    @clothes = Clothes.all
    @cafes = Cafe.all
    gon.clothes = @clothes
    gon.cafes = @cafes
    gon.latitude = 35.6813843233819
    gon.longitude = 139.76712479697295
  end
end
