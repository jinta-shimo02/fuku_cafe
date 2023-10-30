# [（仮）服カフェ]

## サービス概要
洋服好き、カフェ好きのためのセレクトショップ・カフェ検索サービスです。
マップ上からショップ検索ができ、気になるショップがあったらリストを作成し保存することができます。

## 想定されるユーザー層
- 洋服・セレクトショップが好きな人
- カフェが好きな人
- おしゃれな洋服を着たいけど、どこに行けばいいか悩んでいる人

## サービスコンセプト
私自身、洋服とカフェが大好きで、セレクトショップを回った後はよくカフェに行きます。ただ、新規で開拓したいときや、いつもとは違うエリアで買い物をしたいときに、どんなセレクトショップがあるのか、その付近にはどんなカフェがあるのかを、インスタやブラウザで検索してはどこかにメモをするという作業に手間を覚えていました。そこで、マップ上からセレクトショップとカフェ# 服カフェ
<img src="app/assets/images/ogp1.png">

## ◾サービス概要
「服カフェ」は、服好き・カフェ好きのためのショップ検索サービスです。マップ上からセレクトショップ・カフェの検索が可能で、気になるショップを作成したリストに保存することができます。

▼**サービスURL**

https://fuku-cafe.com

▼**Qiita記事**

今後追加予定

▼**告知ツイート**

https://twitter.com/jin_XXX222/status/1718535233807736948

<br>

## ◾主な機能

### メイン機能
|マップ検索|フィルター検索|ブランド検索|
|--------|----------|---------|
|![search_map](https://github.com/jinta-shimo02/fuku_cafe/assets/100778581/6ad4017e-0bad-4afc-98bb-fb0d83008782)|![filter](https://github.com/jinta-shimo02/fuku_cafe/assets/100778581/a395f6f7-95e9-4db9-9615-04cf7567a99e)|![brand_filter](https://github.com/jinta-shimo02/fuku_cafe/assets/100778581/73a7fe89-775f-44ba-b253-b8a7c9300195)|
|マップをスワイプすると、サークル内で自動検索がかかります。|セレクトショップのみ、カフェのみでのフィルター検索が可能です。|特定のブランドを取り扱っているショップを検索することも可能です。|

|リスト保存|ショップレビュー|レコメンド|
|-------|-----------|------|
|![save_list](https://github.com/jinta-shimo02/fuku_cafe/assets/100778581/8363ed39-0d00-4343-ada8-004f91d4d5b6)|![review](https://github.com/jinta-shimo02/fuku_cafe/assets/100778581/8ac44c0b-d8b3-4455-a793-ea9791c94031)|![recommend](https://github.com/jinta-shimo02/fuku_cafe/assets/100778581/2d1eaffa-5687-4ccc-9e25-4643ee6edf02)|
|気になるショップを作成したリストへ保存することができます。|ショップへのレビューをすることができます。|ショップ詳細画面で、1番近くにあるショップをレコメンドします。|

### その他機能
- マイページ（リスト編集、レビュー一覧）
- 現在地から検索
- 場所検索（ピンの位置を移動する） 

<br>

## ◾使用技術
### バックエンド
- Ruby 3.2.2
- Ruby on Rails 7.0.6
- PostgreSQL
- gem
  - devise
  - google_places
  - gon
  - geokit-rails
  - kaminari
- API
  - Google Maps JavaScript API
  - Google Places API
  - Google Geolocation API

### フロントエンド
- Tailwind CSS
- Hotwire(Turbo, Stimulus)

### インフラ
- Heroku

<br>

## ◾画面遷移図
https://www.figma.com/file/nxcfgLn3ZBsy3X9eND5Yrw/%E6%9C%8D%E3%82%AB%E3%83%95%E3%82%A7?type=design&node-id=0%3A1&mode=design&t=evAGQB4W63ESGNiF-1

<br>

## ◾ER図
https://drive.google.com/file/d/104nx7IbtZpK-tIywO-Wn9RLoy1t0eg2n/view?usp=drive_link

<br>を同時に検索でき、気になったお店を保存できるサービスがあると便利だと思いこのサービスを考えました。

## 実装を予定している機能
### MVP
- 会員登録
- ログイン・ログアウト
- マップ（GoogleMap）機能
	- セレクトショップとカフェは、表示するマーカーを変えて区別
- 検索機能
	- セレクトショップのみ検索
	- カフェのみ検索
	- 取扱ブランドで検索
- セレクトショップ・カフェ詳細機能
	- 店名、住所、電話番号、営業時間、店舗画像、取扱ブランド（セレクトショップのみ）
- リスト保存機能（会員限定）
	- リストを作成し、気になったショップを保存

### その後の機能
- 検索機能
	- 現在地から近くのお店を検索
- ショップレビュー機能（会員限定）
- レコメンド機能（会員限定）

### 画面遷移図
https://www.figma.com/file/nxcfgLn3ZBsy3X9eND5Yrw/%E6%9C%8D%E3%82%AB%E3%83%95%E3%82%A7?type=design&node-id=0%3A1&mode=design&t=evAGQB4W63ESGNiF-1

### ER図
https://drive.google.com/file/d/104nx7IbtZpK-tIywO-Wn9RLoy1t0eg2n/view?usp=drive_link