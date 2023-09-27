class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :set_brands
  before_action :set_lists

  def after_sign_in_path_for(resource)
    home_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def set_brands
    @brands = Brand.all
  end

  def set_lists
    if current_user
      @shop_saved_lists = current_user.shop_saved_lists
    end
  end
end
