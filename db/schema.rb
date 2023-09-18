# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_09_06_140246) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "list_shops", force: :cascade do |t|
    t.bigint "shop_saved_list_id"
    t.bigint "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_list_shops_on_shop_id"
    t.index ["shop_saved_list_id", "shop_id"], name: "index_list_shops_on_shop_saved_list_id_and_shop_id", unique: true
    t.index ["shop_saved_list_id"], name: "index_list_shops_on_shop_saved_list_id"
  end

  create_table "shop_brands", force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "brand_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_shop_brands_on_brand_id"
    t.index ["shop_id", "brand_id"], name: "index_shop_brands_on_shop_id_and_brand_id", unique: true
    t.index ["shop_id"], name: "index_shop_brands_on_shop_id"
  end

  create_table "shop_images", force: :cascade do |t|
    t.string "image"
    t.bigint "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_shop_images_on_shop_id"
  end

  create_table "shop_saved_lists", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_shop_saved_lists_on_user_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "type", null: false
    t.string "name", null: false
    t.string "postal_code"
    t.string "address"
    t.string "phone_number"
    t.string "opening_hours"
    t.decimal "latitude", precision: 10, scale: 7, null: false
    t.decimal "longitude", precision: 10, scale: 7, null: false
    t.string "place_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "web_site"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.integer "role", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "list_shops", "shop_saved_lists"
  add_foreign_key "list_shops", "shops"
  add_foreign_key "shop_brands", "brands"
  add_foreign_key "shop_brands", "shops"
  add_foreign_key "shop_images", "shops"
  add_foreign_key "shop_saved_lists", "users"
end
