class AddWebsiteToShops < ActiveRecord::Migration[7.0]
  def change
    add_column :shops, :web_site, :string
  end
end
