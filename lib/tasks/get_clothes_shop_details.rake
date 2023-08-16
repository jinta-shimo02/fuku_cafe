require 'csv'
require 'open-uri'

namespace :Clothes_shops do
  desc 'Fetch and save shop details'
  task :get_and_save_details => :environment do
    API_KEY = ENV['API_KEY']

    def get_place_id(phone_number)
      client = GooglePlaces::Client.new(API_KEY)
      spot = client.spots_by_query(phone_number).first
      spot.place_id if spot
    end

    def get_detail_data(shop)
      place_id = get_place_id(shop['電話番号'])

      if place_id
        existing_shop = Shop.find_by(place_id: place_id) # データベース内を検索
        if existing_shop
          puts "既に保存済みです: #{shop['店名']}"
          return nil
        end

        place_detail_query = URI.encode_www_form(
          place_id: place_id,
          language: 'ja',
          key: API_KEY
        )
        place_detail_url = "https://maps.googleapis.com/maps/api/place/details/json?#{place_detail_query}"
        place_detail_page = URI.open(place_detail_url).read
        place_detail_data = JSON.parse(place_detail_page)

        result = {}
        result[:type] = 'Clothes'
        result[:name] = shop['店名']
        result[:postal_code] = place_detail_data['result']['address_components'].find { |c| c['types'].include?('postal_code') }&.fetch('long_name', nil)

        full_address = place_detail_data['result']['formatted_address']
        result[:address] = full_address.sub(/\A[^ ]+/, '')
        
        result[:phone_number] = place_detail_data['result']['formatted_phone_number']
        result[:opening_hours] = place_detail_data['result']['opening_hours']['weekday_text'].join("\n") if place_detail_data['result']['opening_hours'].present?
        result[:latitude] = place_detail_data['result']['geometry']['location']['lat']
        result[:longitude] = place_detail_data['result']['geometry']['location']['lng']
        result[:place_id] = place_id
        result[:web_site] = place_detail_data['result']['website']

        result
      else
        puts "詳細情報が見つかりませんでした。"
        nil
      end
    end

    def photo_reference_data(shop_data)
      if shop_data
        place_id = shop_data[:place_id]
        place_detail_query = URI.encode_www_form(
          place_id: place_id,
          language: 'ja',
          key: API_KEY
        )
        place_detail_url = "https://maps.googleapis.com/maps/api/place/details/json?#{place_detail_query}"
        place_detail_page = URI.open(place_detail_url).read
        place_detail_data = JSON.parse(place_detail_page)

        photos = place_detail_data['result']['photos']
        photo_references = []

        if photos.present?
          photos.take(5).each do |photo|
            photo_references << photo['photo_reference']
          end
          photo_references
        else
          nil
        end
      else
        puts "詳細情報がありません"
        return nil
      end
    end

    csv_file = 'lib/clothes_shop.csv'
    
    CSV.foreach(csv_file, headers: true) do |row|
      shop_data = get_detail_data(row)
      if shop_data
        shop = Shop.create!(shop_data)
        puts "Shop(Clothes)を保存しました: #{row['店名']}"
        puts "----------"
      else
        puts "Shop(Clothes)の保存に失敗しました: #{row['店名']}"
      end

      photo_references = photo_reference_data(shop_data)
      if photo_references.present?
        photo_references.each do |photo|
          ShopImage.create!(shop: shop, image: photo)
        end
          puts "ShopImageを保存しました: #{row['店名']}"
          puts "----------"
      else
        puts "ShopImageの保存に失敗しました: #{row['店名']}"
      end
    end
  end
end
