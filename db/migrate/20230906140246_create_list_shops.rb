class CreateListShops < ActiveRecord::Migration[7.0]
  def change
    create_table :list_shops do |t|
      t.references :shop_saved_list, foreign_key: true
      t.references :shop, foreign_key: true

      t.timestamps
    end

    add_index :list_shops, [:shop_saved_list_id, :shop_id], unique: true
  end
end
