module MapConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_map_data, only: :home
  end

  def set_map_data
    gon.latitude = 35.6813843233819
    gon.longitude = 139.76712479697295
    gon.api_key = ENV['API_KEY']
    gon.user_logged_in = user_signed_in?
  end
end