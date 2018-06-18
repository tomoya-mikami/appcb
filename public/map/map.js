// google mapの初期位置
var defaultPostion = {lat: 36.090707, lng: 140.098846}
var now_index = 0;
var marker_array = [];
var disasters;
var disaster_index = 0;

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
        var map = new google.maps.Map(document.getElementById('map'), {
            center: latLng,
            zoom: 18
				});

				var my_marker = new google.maps.Marker({
					position: latLng,
					map: map,
				});
				
				map.addListener('click', function(e) {
					// console.log(e);
					getClickLatLng(e.latLng, map);
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
		var map = new google.maps.Map(document.getElementById('map'), {
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
    var set_disater_id = 0;
		disasters = data['results'];
    disasters.forEach(element => {
			$("#disaster_table").append($(`<tr id= "disaster_table_${set_disater_id}" onclick="change_marker(${set_disater_id++})"><td><img src="${element['image']['url']}">${element['disaster_name']}</td></tr>`));
		});
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
		icon: disasters[disaster_index]['image']['url'],
  });
  marker_array[now_index] = marker;

  // 住所を取得する
  var adress = 'default';
  $.ajax({
		url:`https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat_lng.lat()},${lat_lng.lng()}&key=AIzaSyC0AFw2GoFMaCGYX1COZ7BZL04fAKONrvM`,
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
  new google.maps.InfoWindow({
      content: content
  }).open(marker.getMap(), marker);
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
  if (marker_array[now_index]) marker_array[now_index].setIcon(disasters[disaster_index]['image']['url']);
}

// ajaxでフォームを送る
document.getElementById('pos_send').onclick = function() {

  $.ajax({
    type: "Get",
    url: location.protocol + "/position/create/",
    dataType: 'json',
    data: {
      latitude: document.getElementById('lat').value,
      longitude: document.getElementById('lng').value,
      description: document.getElementById('description').value,
			position_type: 1,
			disaster_id: $("#disaster_id").val()
    }
  }).done(function(data){
    console.log(data);
    document.getElementById('lat').value = '';
    document.getElementById('lng').value = '';
    document.getElementById('description').value = '';
		now_index++;
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
})