class CreateShopSavedLists < ActiveRecord::Migration[7.0]
  def change
    create_table :shop_saved_lists do |t|
      t.string :name, null: false
      t.references :user, foreign_key: true
      
      t.timestamps
    end
  end
end
