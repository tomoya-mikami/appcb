// google mapの初期位置
var defaultPostion = {lat: 36.090707, lng: 140.098846}
var map = null;
marker = [];
var disasters;

// 災害情報表示用のデータを持ってくる
function initMap() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      function(position) {
        latLng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);

        // 地図の作成
        map = new google.maps.Map(document.getElementById('map'), {
            center: latLng,
            zoom: 18
        });

        var my_marker = new google.maps.Marker({
					position: latLng,
					map: map,
        });
      },
      function(error) {
        console.log(error);
      }
    );
  } else {
    alert('GPSを利用できません');
  }

  if ( ! map) {
		map = new google.maps.Map(document.getElementById('map'), {
			center: defaultPostion,
			zoom: 14
		});
	
		map.addListener('click', function(e) {
			// console.log(e);
			getClickLatLng(e.latLng, map);
    });
	}

	$.ajax({
		type: "Get",
		url: location.protocol + "/disasters/index/",
		dataType: 'json',
	}).done(function(data){
    console.log(data['error']);
    disasters = data['results'];
	}).fail(function(jqXHR, textStatus, errorThrown){
		console.log(jqXHR);
		console.log(textStatus);
		console.log(errorThrown);
  })

  setInterval("getPostion()",3000);
}

function getPostion() {
  $.ajax({
    type: "Get",
    url: location.protocol + "/position/index/",
    dataType: 'json',
  }).done(function(data){
    var disaster_id = 0;
    data['results'].forEach(element => {
      var disaster_icon = null;
      var position_image = null;
      if (element['disaster_id']) {
        disaster_id = element['disaster_id'] - 1;
        if (disasters[disaster_id]['image']['icon']['url']) disaster_icon = disasters[disaster_id]['image']['icon']['url'];
      } else if (element['image']) {
        if (element['image']['icon']['url']) disaster_icon = element['image']['icon']['url'];
        if (element['image']['map_information']['url']) position_image = element['image']['map_information']['url'];
      }
      set_marker(Number(element['latitude']), Number(element['longitude']), disaster_icon, map, position_image);
    });
  }).fail(function(jqXHR, textStatus, errorThrown){
    console.log(jqXHR);
    console.log(textStatus);
    console.log(errorThrown);
  })
}

function set_marker(_lat, _lng, _icon, _map, image = null) {
  var marker =  new google.maps.Marker({ 
    position: {lat: _lat, lng: _lng}, 
    icon: _icon, 
    map: _map 
  });
  marker.addListener('click', function(){
    markerInfo(marker, _lat, _lng, image);
  });
  return marker;
}

function markerInfo(marker, _lat, _lng, image = null) {
  console.log(image);
  var content = `<p style="font-size: 2vh;">緯度 : ${_lat} 経度 : ${_lng}</p>`
  if (image) content += `<p><img src="${location.protocol +image}"></p>`
  new google.maps.InfoWindow({
      content: content
  }).open(marker.getMap(), marker);
}