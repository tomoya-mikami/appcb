// google mapの初期位置
var defaultPostion = {lat: 36.090707, lng: 140.098846}
var now_index = 0;
var marker_array = [];
var disasters;

// selectboxの初期化, サーバーから災害のデータを引っ張ってくる
function init() {
	$.ajax({
		type: "Get",
		url: location.protocol + "/disasters/index/",
		dataType: 'json',
	}).done(function(data){
		console.log(data);
		disasters = data['results'];
		disasters.forEach(element => {
			$("#disaster_id").append($("<option>").val(element['id']).text(element['disaster_name']));
		});
	}).fail(function(jqXHR, textStatus, errorThrown){
		console.log(jqXHR);
		console.log(textStatus);
		console.log(errorThrown);
	})
}

// googlemapの初期化
function initMap() {
	// Create a map object and specify the DOM element for display.
	var map = new google.maps.Map(document.getElementById('map'), {
		center: defaultPostion,
		zoom: 14
	});

	map.addListener('click', function(e) {
		// console.log(e);
		getClickLatLng(e.latLng, map);
	});
}

// マーカーの設置とフォームの作成
function getClickLatLng(lat_lng, map) {
		
	$.ajax({
		url:`https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat_lng.lat()},${lat_lng.lng()}&key=AIzaSyC0AFw2GoFMaCGYX1COZ7BZL04fAKONrvM`,
		type:'get',
	}).done((data) => {
		var text = 'error';
		result = data['results'];
		if(result.length > 0)
		{
			text = result[0]["formatted_address"];
		}
		document.getElementById('address').innerHTML = `<p>住所 : ${text}</p>`;
		console.log('success');
		console.log(data);
	}).fail((data) => {
		console.log('fail');
		console.log(data);
	});

	if(marker_array[now_index]) {
		marker_array[now_index].setMap(null);
	}

	// 現在表示選択されている要素を取得
	var select_disaster_id = $("#disaster_id").val() - 1;

	// 座標を表示
	document.getElementById('lat').value = lat_lng.lat();
	document.getElementById('lng').value = lat_lng.lng();

	// マーカーを設置
	var marker = new google.maps.Marker({
	  position: lat_lng,
		map: map,
		icon: disasters[select_disaster_id]['image']['url'],
	});
	marker_array[now_index] = marker;

	// 座標の中心をずらす
	// http://syncer.jp/google-maps-javascript-api-matome/map/method/panTo/
	// map.panTo(lat_lng);
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
$("#disaster_id").change(function(){
	if (marker_array[now_index]) {
		var select_disaster_id = $("#disaster_id").val() - 1;
		marker_array[now_index].setIcon(disasters[select_disaster_id]['image']['url']);
	}
})