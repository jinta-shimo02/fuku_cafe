require 'csv'

csv_file = 'lib/brands.csv'

namespace :brands do
  desc 'save brands'
  task save_to_table: :environment do
    CSV.foreach(csv_file, headers: true) do |row|
      brand_name = row['ブランド名']

      unless Brand.exists?(name: brand_name)
        brand = Brand.new(name: brand_name)

        if brand.save
          puts "ブランド：#{brand_name}を保存しました。"
        else
          puts "ブランド：#{brand_name}の保存に失敗しました。"
          puts "#{brand.errors.full_messages}"
        end
      else
        puts "ブランド：#{brand_name}は既に保存されています。"
      end
    end
  end
end
