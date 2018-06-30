// google mapの初期位置
var defaultPostion = {lat: 36.090707, lng: 140.098846}
var map;
var now_index = 0;
var marker_array = [];
var get_marker_array = [];
var position_id = 0;
var disasters;
var disaster_index = 0;
var project_token = '';
var google_map_api_key = '';
var infowindow;

//projectトークンを設定する
function initToken(token, api_key) {
  project_token = token;
  google_map_api_key = api_key;
}

// ページの初期化関数
// 座標の取得
// selectboxの初期化
// googlemapの初期化
function initMap() {
	if (navigator.geolocation) {
		navigator.geolocation.getCurrentPosition(
			function(position) {
				console.log(position);
				latLng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
 
        // 地図の作成
        map = new google.maps.Map(document.getElementById('map'), {
            center: latLng,
            zoom: 18
        });
        console.log(map);

				var my_marker = new google.maps.Marker({
					position: latLng,
					map: map,
				});
				
				map.addListener('click', function(e) {
					// console.log(e);
					getClickLatLng(e.latLng, map);
        });
        setInterval("getPostion()",3000);
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
    data: {
      project_token: project_token
    }
	}).done(function(data){
    var set_disater_id = 0;
		disasters = data['results'];
    disasters.forEach(element => {
			$("#disaster_table").append($(`<tr id= "disaster_table_${set_disater_id}" onclick="change_marker(${set_disater_id++})"><td><img src="${element['image']['table_image']['url']}">${element['disaster_name']}</td></tr>`));
    });
    console.log(disasters);
	}).fail(function(jqXHR, textStatus, errorThrown){
		console.log(jqXHR);
		console.log(textStatus);
		console.log(errorThrown);
  });
}

// マーカーの設置とフォームの作成
function getClickLatLng(lat_lng, map) {

	if(marker_array[now_index]) {
		marker_array[now_index].setMap(null);
	}

	// 送信する座標をセット
	document.getElementById('lat').value = lat_lng.lat();
	document.getElementById('lng').value = lat_lng.lng();

	// マーカーを設置
	var marker = new google.maps.Marker({
	  position: lat_lng,
		map: map,
		icon: disasters[disaster_index]['image']['icon']['url'],
  });
  marker_array[now_index] = marker;

  // 住所を取得する
  var adress = 'default';
  $.ajax({
		url:`https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat_lng.lat()},${lat_lng.lng()}&key=${google_map_api_key}`,
		type:'get',
	}).done((data) => {
		var text = 'error';
		result = data['results'];
		if(result.length > 0)
		{
			adress = result[0]["formatted_address"];
    }
    markerInfo(marker, adress);
		//document.getElementById('address').innerHTML = `<p>住所 : ${adress}</p>`;
		console.log('success');
	}).fail((data) => {
		console.log('fail');
		console.log(data);
	});

	// 座標の中心をずらす
	// http://syncer.jp/google-maps-javascript-api-matome/map/method/panTo/
	// map.panTo(lat_lng);
}

// マーカーに情報ウインドウを表示する
function markerInfo(marker, adress) {
  var content = `<p style="font-size: 2vh;">${adress}</p>`
  infowindow = new google.maps.InfoWindow({
    content: content
  })
  infowindow.open(marker.getMap(), marker);
}

// 横のアイコンをタッチするとマーカーの種類が変わる
function change_marker(_id) {
  // 選択されているものの背景色をリセット
  $("#disaster_table tr").each(function(index , elm){
    $(elm).removeClass('table-info');
  });
  disaster_index = _id;
  document.getElementById(`disaster_table_${disaster_index}`).classList.add('table-info');
  document.getElementById('disaster_id').value = disasters[disaster_index]['id'];
  if (marker_array[now_index]) marker_array[now_index].setIcon(disasters[disaster_index]['image']['icon']['url']);
}

// ajaxでフォームを送る
document.getElementById('pos_send').onclick = function() {

  $.ajax({
    type: "POST",
    url: location.protocol + "/position/create/",
    dataType: 'json',
    data: {
      latitude: document.getElementById('lat').value,
      longitude: document.getElementById('lng').value,
      description: document.getElementById('description').value,
			position_type: 1,
      disaster_id: $("#disaster_id").val(),
      project_token: project_token
    }
  }).done(function(data){
    console.log(data);
    if (data['error'])
    {
      document.getElementById('error-modal-body').innerHTML = '';
      data['message']['error'].forEach(element => {
        document.getElementById('error-modal-body').innerHTML += `<p>${element}</p>`;
      });
      $('#error_modal').modal();
    } else {
      document.getElementById('lat').value = '';
      document.getElementById('lng').value = '';
      document.getElementById('description').value = '';
      $('#success_modal').modal();
      infowindow.close();
      now_index++;
    }
  }).fail(function(jqXHR, textStatus, errorThrown){
    console.log(jqXHR);
    console.log(textStatus);
    console.log(errorThrown);
  })

}

// セレクトボックスの値が変わったときにアイコンを変更する
$("#disaster_id").change(function() {
	if (marker_array[now_index]) {
		var select_disaster_id = $("#disaster_id").val() - 1;
		marker_array[now_index].setIcon(disasters[select_disaster_id]['image']['url']);
	}
});

function getPostion() {
  $.ajax({
    type: "Get",
    url: location.protocol + "/position/index/",
    dataType: 'json',
    data: {
      project_token: project_token,
      position_id: position_id,
    },
  }).done(function(data){
    var disaster_id = 0;
    if (data['error']) {
      console.log(data);
    } else {
      data['results'].forEach(element => {
        var disaster_icon = null;
        var position_image = null;
        if (element['disaster_id']) {
          disaster_id = element['disaster_id'] - 1;
          if (disasters[disaster_id] && disasters[disaster_id]['image']['icon']['url']) disaster_icon = disasters[disaster_id]['image']['icon']['url'];
        } else if (element['image']) {
          if (element['image']['icon']['url']) disaster_icon = element['image']['icon']['url'];
          if (element['image']['map_information']['url']) position_image = element['image']['map_information']['url'];
        }
        get_marker_array.push(set_marker(Number(element['latitude']), Number(element['longitude']), disaster_icon, map, position_image));
      });
      if (data['results'].length > 0) {
        last_position = data['results'][data['results'].length - 1];
        position_id = last_position.id
      }
    }
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
    getmarkerInfo(marker, _lat, _lng, image);
  });
  marker.setVisible(false);
  return marker;
}

function getmarkerInfo(marker, _lat, _lng, image = null) {
  console.log(image);
  var content = `<p style="font-size: 2vh;">緯度 : ${_lat} 経度 : ${_lng}</p>`
  if (image) content += `<p><img src="${location.protocol +image}"></p>`
  new google.maps.InfoWindow({
      content: content
  }).open(marker.getMap(), marker);
}

function VisibleGetMarker() {
  get_marker_array.forEach(element => {
    element.setVisible(true);
  });
}

function UnVisibleGetMarker() {
  get_marker_array.forEach(element => {
    element.setVisible(false);
  });
}

function move_default_point() {
  map.panTo(new google.maps.LatLng(37.637664884279005, 138.90591575798942));
  map.setZoom(17);
}