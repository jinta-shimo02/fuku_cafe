class BrandsController < ApplicationController
  layout false
  def search
    query = params[:q].downcase
    @brands = Brand.where("LOWER(name) like ?", "%#{query}%").limit(5)
    @cafes = Cafe.where("LOWER(name) like ?", "%#{query}%").limit(5)
    @clothes = Clothes.where("LOWER(name) like ?", "%#{query}%").limit(5)
  end
end
