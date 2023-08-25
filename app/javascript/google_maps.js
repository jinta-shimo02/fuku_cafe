var map;
var pin;
var circle;
var lat = gon.latitude;
var lng = gon.longitude;
var clothes = gon.clothes;
var cafes = gon.cafes;
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
    radius: 700,
    strokeColor: "#FF0000", // 線の色
    strokeOpacity: 0.8, // 線の不透明度
    strokeWeight: 2, // 線の太さ
    fillColor: "#FF0000", // 塗りつぶしの色
    fillOpacity: 0.35, // 塗りつぶしの不透明度
  });
  // マップをドラッグした時の動作
  map.addListener('dragend', function() {
    var pin_center = pin.setPosition(map.getCenter());
    var circle_center = circle.setCenter(map.getCenter());
  });
  // ピンをドラッグした時の動作
  pin.addListener('dragend', function() {
    var circle_position = circle.setCenter(pin.getPosition());
  })
}
