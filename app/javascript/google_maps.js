var map;
var pin;
var circle;
var marker;
var lat = gon.latitude;
var lng = gon.longitude;
var clothesMarker = [];
var cafesMarker = [];
var API_KEY = gon.api_key

// 地図の初期化
window.initMap = function() {
  map = new google.maps.Map(document.getElementById("map"), {
    zoom: 15,
    center: new google.maps.LatLng(lat, lng),
    mapTypeId: 'roadmap',
    zoomControl: true,
    streetViewControl: true,
    fullscreenControl: false,
    mapTypeControl: false,
    draggable: true,
    scrollwhell: true,
    diableDoubleClickZoom: true,
    gestureHandling: 'greedy',
    styles: [
              {
                featureType: 'all',
                elementType: 'all',
              },
              {
                featureType: 'poi',
                elementType: 'all',
                stylers: [
                  {visibility: 'off'},
                ],
              }
      ]
  });

  // ピンの初期化
  pin = new google.maps.Marker({
    map: map,
    draggable: true,
    position: new google.maps.LatLng(lat, lng),
  });

  // サークルの初期化
  circle = new google.maps.Circle({
    map: map,
    center: new google.maps.LatLng(lat, lng),
    radius: 1000,
    strokeColor: "#FF0000", // 線の色
    strokeOpacity: 0.8, // 線の不透明度
    strokeWeight: 2, // 線の太さ
    fillColor: "#FF0000", // 塗りつぶしの色
    fillOpacity: 0.35, // 塗りつぶしの不透明度
  });

  // マップをドラッグした時の動作
  map.addListener('dragend', function() {
    var newPinCenter = pin.setPosition(map.getCenter());
    circle.setCenter(map.getCenter());

    var circleCenter = circle.getCenter();
    var radius = circle.getRadius();

    // サークルの東西南北の緯度経度を取得
    var circleBounds = {
      north: circleCenter.lat() + radius / 111111,
      south: circleCenter.lat() - radius / 111111,
      east: circleCenter.lng() + radius / (111111 * Math.cos(circleCenter.lat() * Math.PI / 180)),
      west: circleCenter.lng() - radius / (111111 * Math.cos(circleCenter.lat() * Math.PI / 180))
    };

    // mapsコントローラのhomeアクションへアクセス（json形式）
    fetch(`/home.json?north=${circleBounds.north}&south=${circleBounds.south}&east=${circleBounds.east}&west=${circleBounds.west}`)
    .then(response => response.json())
    .then(data => {
      clearMarkers();
      addMarkers(data.clothes, 'Clothes');
      addMarkers(data.cafes, 'Cafe');
    
      const clothesListElement = document.getElementById('clothes-list');
    
      // 以前の内容をクリア
      clothesListElement.innerHTML = '';
    
      // ヒットしたショップを一覧で表示する（セレクトショップ）
      if (data.clothes.length > 0) {
        data.clothes.forEach(shop => {

          const clothes_image = shop.shop_images[0];

          const shopCard = document.createElement('div');
          shopCard.className = 'card bg-base-200 border-gray-500 shadow-xl m-5';

          const cardContent = `
            <div class="flex">
              <img src="https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photo_reference=${clothes_image.image}&key=${API_KEY}" class="p-5 w-48 h-48 rounded-3xl">
              <div class="flex-col">
                <ul>
                  <li class="pl-6 pt-6 text-3xl underline">${shop.name}</li>
                  <li class="pl-6 pt-4">${shop.address}</li>
                  <li class="pl-6 pt-1.5">${shop.phone_number}</li>
                </ul>
              </div>
            </div>
          `;
  
          shopCard.innerHTML = cardContent;
          clothesListElement.appendChild(shopCard);
        });
      } else {
        // ショップが存在しない場合の処理
        const noClothesShopElement = document.createElement('p');
        noClothesShopElement.textContent = '近くにショップはありません';
        noClothesShopElement.className = 'text-2xl pt-5 text-center'
        clothesListElement.appendChild(noClothesShopElement);
      }

      const cafesListElement = document.getElementById('cafes-list');
    
      // 以前の内容をクリア
      cafesListElement.innerHTML = '';
    
      // ヒットしたショップの一覧を表示（カフェ）
      if (data.cafes.length > 0) {
        data.cafes.forEach(shop => {
        
          const cafe_image = shop.shop_images[0];

          const shopCard = document.createElement('div');
          shopCard.className = 'card bg-base-200 border-gray-500 shadow-xl m-5';
  
          const cardContent = `
            <div class="flex">
              <img src="https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photo_reference=${cafe_image.image}&key=${API_KEY}" class="p-5 w-48 h-48 rounded-3xl">
              <div class="flex-col">
                <ul>
                  <li class="pl-6 pt-6 text-3xl underline">${shop.name}</li>
                  <li class="pl-6 pt-4">${shop.address}</li>
                  <li class="pl-6 pt-1.5">${shop.phone_number}</li>
                </ul>
              </div>
            </div>
          `;
  
          shopCard.innerHTML = cardContent;
          cafesListElement.appendChild(shopCard);
        });
      } else {
        // ショップが存在しない場合の処理
        const noCafeShopElement = document.createElement('p');
        noCafeShopElement.textContent = '近くにショップはありません';
        noCafeShopElement.className = 'text-2xl py-5 text-center'
        cafesListElement.appendChild(noCafeShopElement);
      }
    })
    .catch(error => console.error('Error:', error));
  });

  // ピンをドラッグした時の動作
  pin.addListener('dragend', function() {
    circle.setCenter(pin.getPosition());
  });
}

// マーカーを表示する
function addMarkers(shops, type) {
  for (var i = 0; i < shops.length; i++) {
    var markerIcon = '/assets/' + type.toLowerCase() + '_' + (i + 1) + '.png';

    marker = new google.maps.Marker({
      map: map,
      position: new google.maps.LatLng(shops[i].latitude, shops[i].longitude),
      icon: markerIcon
    });

    if (type === 'Clothes') {
      clothesMarker.push(marker);
    } else if (type === 'Cafe') {
      cafesMarker.push(marker)
    }
  }
}

// マーカーを削除する
function clearMarkers() {
  for (var i = 0; i < clothesMarker.length; i++) {
    clothesMarker[i].setMap(null);
  }
  for (var i = 0; i < cafesMarker.length; i++) {
    cafesMarker[i].setMap(null);
  }
  clothesMarker = [];
  cafesMarker = [];
}
