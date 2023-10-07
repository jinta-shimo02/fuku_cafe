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
      shopCard.className = 'card bg-base-200 border-gray-500 shadow-xl m-5';

      const cardContent = `
        <div class="flex" data-controller="modal">
          <img src="https://maps.googleapis.com/maps/api/place/photo?maxheight=200&maxwidth=200&photo_reference=${shop_image.image}&key=${API_KEY}" class="p-3 md:p-5 w-20 h-20 md:w-48 md:h-48 rounded-3xl">
          <div class="flex-col">
            <ul>
              <li class="md:pl-4 mt-3 md:pt-3 text-sm md:text-3xl underline hover:text-yellow-500"><a href="/shops/${shop.id}">${shop.name}</a></li>
              <li class="md:pl-4 mt-1.5 md:pt-2 text-xs md:text-base">${shop.address}</li>
              <li class="md:pl-4 pt-1.5 pb-1 text-sm md:text-base">${shop.phone_number}</li>
              <a href="https://www.google.com/maps/search/?api=1&query=${shop.name}&query_place_id=${shop.place_id}" target=_"blank" rel="noopener noreferrer">
              <li class="mb-1.5 py-3 px-3 text-sm md:text-base text-center rounded-full bg-blue-500 text-white font-bold w-24 md:w-48 hidden md:block hover:bg-gray-300">
                <i class="fa-solid fa-location-dot"></i>
                GoogleMapで見る
              </li>
              </a>
            </ul>
          </div>
            <a href="/shop_saved_lists" data-turbo-frame="modal" class="ml-auto mr-3 mt-auto mr-5 md:mr-10 m-5 bookmark-icon" data-shop-id="${shop.id}">
            ${userIsLoggedIn ? '<i class="fa-solid fa-plus w-7 g-4 md:w-14 md:h-8 hover:text-yellow-500" data-modal-target="myModal"></i>' : ''}
            </a>
        </div>
      `;

      shopCard.innerHTML = cardContent;
      shopsListElement.appendChild(shopCard);
    });
  } else {
    const noShopsElement = document.createElement('p');
    noShopsElement.textContent = '近くにショップはありません';
    noShopsElement.className = 'text-base md:text-2xl pt-5 text-center';
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
      content: '<div><strong>' + shops[i].name + '</strong></div>'
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
