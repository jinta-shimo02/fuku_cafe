class CreateShopImages < ActiveRecord::Migration[7.0]
  def change
    create_table :shop_images do |t|
      t.string :image
      t.references :shop, foreign_key: true

      t.timestamps
    end
  end
end
