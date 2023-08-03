class CreateShops < ActiveRecord::Migration[7.0]
  def change
    create_table :shops do |t|
      t.string :type, null: false
      t.string :name, null: false
      t.string :postal_code
      t.string :address
      t.string :phone_number
      t.string :opening_hours
      t.decimal :latitude, precision: 10, scale: 7, null: false
      t.decimal :longitude, precision: 10, scale: 7, null: false
      t.string :place_id, null: false

      t.timestamps
    end
  end
end
