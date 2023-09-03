var map;
var pin;
var circle;
var lat = gon.latitude;
var lng = gon.longitude;
var clothesMarker = [];
var cafesMarker = [];
var API_KEY = gon.api_key;
var currentFilter = 'all';
var maxMarkers = 10;

function initMap() {
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
          { visibility: 'off' },
        ],
      }
    ]
  });

  pin = new google.maps.Marker({
    map: map,
    draggable: true,
    position: new google.maps.LatLng(lat, lng),
  });

  circle = new google.maps.Circle({
    map: map,
    center: new google.maps.LatLng(lat, lng),
    radius: 1000,
    strokeColor: "#FF0000",
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: "#FF0000",
    fillOpacity: 0.35,
  });

  
  document.getElementById('search-clothes-button').addEventListener('click', function () {
    currentFilter = 'clothes';
    filterSearch(currentFilter);
  });

  document.getElementById('search-cafe-button').addEventListener('click', function () {
    currentFilter = 'cafe';
    filterSearch(currentFilter);
  });

  var brandButtons = document.querySelectorAll('[id^="search-brand-button-"]');
  brandButtons.forEach(function(button) {
    button.addEventListener('click', function(event) {
      var clickedElement = event.target;
      var brandName = clickedElement.textContent;
      currentFilter = 'brand';
      filterSearch(currentFilter, brandName);

      var dropdown = button.closest('.dropdown');
      if (dropdown) {
        dropdown.removeAttribute('open');
      }
    });
  });


  map.addListener('dragend', updateSearch);
  pin.addListener('dragend', updateSearch);
}

function updateSearch() {
  pin.setPosition(map.getCenter());
  circle.setCenter(map.getCenter());
  filterSearch(currentFilter);
}

function filterSearch(filterType, brandName) {
  var circleCenter = circle.getCenter();
  var radius = circle.getRadius();
  var circleBounds = {
    north: circleCenter.lat() + radius / 111111,
    south: circleCenter.lat() - radius / 111111,
    east: circleCenter.lng() + radius / (111111 * Math.cos(circleCenter.lat() * Math.PI / 180)),
    west: circleCenter.lng() - radius / (111111 * Math.cos(circleCenter.lat() * Math.PI / 180))
  };

  var filterParam = '';

  if (filterType === 'cafe') {
    filterParam = 'is_cafe_filter=true';
  } else if (filterType === 'clothes') {
    filterParam = 'is_clothes_filter=true';
  } else if (filterType === 'brand') {
    filterParam = 'brand_name=' + brandName;
  } 

  fetch(`/home.json?north=${circleBounds.north}&south=${circleBounds.south}&east=${circleBounds.east}&west=${circleBounds.west}&${filterParam}`)
    .then(response => response.json())
    .then(data => {
      clearMarkers();
      updateShopList('clothes', data.clothes);
      updateShopList('cafes', data.cafes);
    })
    .catch(error => console.error('Error:', error));
}

function updateShopList(type, shops) {
  const shopsListElement = document.getElementById(`${type}-list`);
  shopsListElement.innerHTML = '';

  if (shops && shops.length > 0) {
    addMarkers(shops, type);

    shops.forEach(shop => {
      const shop_image = shop.shop_images[0];

      const shopCard = document.createElement('div');
      shopCard.className = 'card bg-base-200 border-gray-500 shadow-xl m-5';

      const cardContent = `
        <div class="flex">
          <img src="https://maps.googleapis.com/maps/api/place/photo?maxheight=200&maxwidth=200&photo_reference=${shop_image.image}&key=${API_KEY}" class="p-5 w-48 h-48 rounded-3xl">
          <div class="flex-col">
            <ul>
              <li class="pl-6 pt-6 text-3xl underline"><a href="/shops/${shop.id}">${shop.name}</a></li>
              <li class="pl-6 pt-4">${shop.address}</li>
              <li class="pl-6 pt-1.5">${shop.phone_number}</li>
            </ul>
          </div>
        </div>
      `;

      shopCard.innerHTML = cardContent;
      shopsListElement.appendChild(shopCard);
    });
  } else {
    const noShopsElement = document.createElement('p');
    noShopsElement.textContent = '近くにショップはありません';
    noShopsElement.className = 'text-2xl pt-5 text-center';
    shopsListElement.appendChild(noShopsElement);
  }
}

function addMarkers(shops, type) {
  const markers = (type === 'clothes') ? clothesMarker : cafesMarker;
  for (var i = 0; i < shops.length && i < maxMarkers; i++) {
    var markerIcon = '/assets/' + type.toLowerCase() + '_' + (i + 1) + '.png';

    marker = new google.maps.Marker({
      map: map,
      position: new google.maps.LatLng(shops[i].latitude, shops[i].longitude),
      icon: markerIcon
    });

    markers.push(marker);
  }
}

function clearMarkers() {
  clothesMarker.forEach(marker => marker.setMap(null));
  cafesMarker.forEach(marker => marker.setMap(null));
  clothesMarker = [];
  cafesMarker = [];
}

window.initMap = initMap;