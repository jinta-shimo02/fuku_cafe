var map;
var pin;
var circle;
var marker;
var lat = gon.latitude;
var lng = gon.longitude;
var clothesMarker = [];
var cafesMarker = [];

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

    var circleCenter = circle.getCenter(); // サークルの中心の緯度経度を取得
    var radius = circle.getRadius(); // サークルの半径を取得
    
    var circleBounds = {
      north: circleCenter.lat() + radius / 111111, // 緯度1度あたりの距離は約111,111メートル
      south: circleCenter.lat() - radius / 111111,
      east: circleCenter.lng() + radius / (111111 * Math.cos(circleCenter.lat() * Math.PI / 180)),
      west: circleCenter.lng() - radius / (111111 * Math.cos(circleCenter.lat() * Math.PI / 180))
    };
    
    fetch(`/search?north=${circleBounds.north}&south=${circleBounds.south}&east=${circleBounds.east}&west=${circleBounds.west}`)
    .then(response => response.json())
    .then(data => {
      console.log(data)
      clearMarkers();
      addMarkers(data.clothes, 'Clothes');
      addMarkers(data.cafes, 'Cafe');
    })
    .catch(error => console.error('Error:', error));
  });

  // ピンをドラッグした時の動作
  pin.addListener('dragend', function() {
    circle.setCenter(pin.getPosition());
  });
}

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
