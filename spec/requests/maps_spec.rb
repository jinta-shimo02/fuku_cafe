require 'rails_helper'

RSpec.describe "Maps", type: :request do
  describe "GET /home" do
    it 'マップ画面の表示に成功すること' do
      get home_path
      expect(response).to have_http_status(:success)
    end
  end
end
