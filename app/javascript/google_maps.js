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
var brandName;
var infoWindow;

function initMap() {
  map = new google.maps.Map(document.getElementById("map"), {
    zoom: 14,
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

  var input = document.getElementById('pac-input');
  var searchBox = new google.maps.places.SearchBox(input);
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
  
  searchBox.addListener('places_changed', function() {
    var places = searchBox.getPlaces();
    if (places.length == 0) {
      return;
    }

    var place = places[0];
    lat = place.geometry.location.lat();
    lng = place.geometry.location.lng();

    pin.setPosition(new google.maps.LatLng(lat, lng));

    circle.setCenter(new google.maps.LatLng(lat, lng));

    map.setCenter(new google.maps.LatLng(lat, lng));
  });

  infoWindow = new google.maps.InfoWindow();
  var currentLocationButton = document.createElement('button');
  currentLocationButton.textContent = "現在地へ移動";
  currentLocationButton.className = "border-2 rounded-full border-orange-400 bg-orange-400 py-2 px-4 md:px-8 mt-2 mr-2 text-center text-xs md:text-base text-white font-bold hover:bg-orange-600";
  map.controls[google.maps.ControlPosition.TOP_RIGHT].push(currentLocationButton);

  currentLocationButton.addEventListener('click', function() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          lat = position.coords.latitude
          lng = position.coords.longitude

          pin.setPosition(new google.maps.LatLng(lat, lng));

          circle.setCenter(new google.maps.LatLng(lat, lng));

          map.setCenter(new google.maps.LatLng(lat, lng));

          infoWindow.setPosition(new google.maps.LatLng(lat, lng));
          infoWindow.setContent("現在地を取得しました");
          infoWindow.open(map);
        },
        () => {
          handleLocationError(true, infoWindow, map.getCenter());
        }
      );
    } else {
      handleLocationError(false, infoWindow, map.getCenter());
    }
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
      brandName = clickedElement.textContent;
      currentFilter = 'brand';
      filterSearch(currentFilter, brandName);
      
      var dropdown = button.closest('.dropdown');
      if (dropdown) {
        dropdown.removeAttribute('open');
      }
    });
  });
  
  document.getElementById('maps_init').addEventListener('click', function() {
    location.reload();
  });
  
  map.addListener('dragend', updateSearch);
  pin.addListener('dragend', updateSearch);
}
window.initMap = initMap;

function updateSearch() {
  pin.setPosition(map.getCenter());
  circle.setCenter(map.getCenter());
  filterSearch(currentFilter, brandName);
}

function filterSearch(filterType, brandName) {
  var circleCenter = circle.getCenter();
  var radius = circle.getRadius();
  var circleLatLng = {
    latitude: circleCenter.lat(),
    longitude: circleCenter.lng()
  };

  var filterParam = '';

  if (filterType === 'cafe') {
    filterParam = 'is_cafe_filter=true';
  } else if (filterType === 'clothes') {
    filterParam = 'is_clothes_filter=true';
  } else if (filterType === 'brand') {
    filterParam = 'brand_name=' + brandName;
  } 

  fetch(`/home.json?latitude=${circleLatLng.latitude}&longitude=${circleLatLng.longitude}&${filterParam}`)
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
  const userIsLoggedIn = gon.user_logged_in;
  
  if (shops && shops.length > 0) {

    const limitedShops = shops.slice(0, 15);

    addMarkers(limitedShops, type);

    limitedShops.forEach(shop => {
      const shop_image = shop.shop_images[0];

      const shopCard = document.createElement('div');
      shopCard.className = 'card w-11/12 bg-base-200 border-gray-500 shadow-xl m-2 md:m-3';

      const cardContent = `
        <div class="flex" data-controller="modal">
          <img src="https://maps.googleapis.com/maps/api/place/photo?maxheight=200&maxwidth=200&photo_reference=${shop_image.image}&key=${API_KEY}" class="p-3 md:p-5 w-20 h-20 md:w-36 md:h-36 rounded-3xl">
          <div class="flex-col">
            <ul>
              <li class="md:pl-2 pt-3 text-[9px] md:text-xl underline hover:text-yellow-500"><a href="/shops/${shop.id}">${shop.name}</a></li>
              <li class="pl-1 md:pl-4 mt-1 md:mt-1.5 text-[7px] md:text-xs">${shop.address}</li>
              <li class="pl-1 md:pl-4 mt-1 md:mt-1.5 text-[7px] md:text-xs">${shop.phone_number}</li>
              <a href="https://www.google.com/maps/search/?api=1&query=${shop.name}&query_place_id=${shop.place_id}" target=_"blank" rel="noopener noreferrer">
              <li class="mb-1.5 py-2 px-2 mt-1 md:mt-1.5 text-[8px] md:text-xs text-center rounded-full bg-blue-500 text-white font-bold w-24 md:w-40 hover:bg-blue-600">
                <i class="fa-solid fa-location-dot"></i>
                GoogleMapで見る
              </li>
              </a>
            </ul>
          </div>
            <a href="/shop_saved_lists" data-turbo-frame="modal" class="ml-auto mr-3 mt-auto mr-3 md:mr-8 mb-3 md:mb-5 bookmark-icon" data-shop-id="${shop.id}">
            ${userIsLoggedIn ? '<i class="fa-solid fa-plus w-7 g-4 md:w-10 md:h-6 hover:text-yellow-500" data-modal-target="myModal"></i>' : ''}
            </a>
        </div>
      `;

      shopCard.innerHTML = cardContent;
      shopsListElement.appendChild(shopCard);
    });
  } else {
    const noShopsElement = document.createElement('p');
    noShopsElement.textContent = '近くにショップはありません';
    noShopsElement.className = 'text-xs md:text-lg pt-5 text-center mb-5';
    shopsListElement.appendChild(noShopsElement);
  }
}

function addMarkers(shops, type) {
  const markers = (type === 'clothes') ? clothesMarker : cafesMarker;
  for (var i = 0; i < shops.length && i < maxMarkers; i++) {
    var markerIcon = '/images/' + type.toLowerCase() + '_' + (i + 1) + '.png';

    let marker = new google.maps.Marker({
      map: map,
      position: new google.maps.LatLng(shops[i].latitude, shops[i].longitude),
      icon: markerIcon
    });

    const infowindow = new google.maps.InfoWindow({
      content: '<div class="hover:text-yellow-500"><a href="/shops/' + shops[i].id + '">' + shops[i].name + '</a></div>'
    });

    marker.addListener('click', function() {
      infowindow.open(map, marker);
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

function handleLocationError(browserHasGeolocation, infoWindow, lat, lng) {
  infoWindow.setPosition(new google.maps.LatLng(lat, lng));
  infoWindow.setContent(
    browserHasGeolocation
      ? "現在地を取得できませんでした"
      : "お使いのブラウザではサポートされていません"
  );
  infoWindow.open(map);
}
