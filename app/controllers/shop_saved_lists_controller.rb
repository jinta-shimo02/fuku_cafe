class ShopSavedListsController < ApplicationController
  def index
    @shop_saved_lists = current_user.shop_saved_lists
  end
  def new; end
  def create; end
end
