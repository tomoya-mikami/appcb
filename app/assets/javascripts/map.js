// google mapの初期位置
var defaultPostion = {lat: 36.090707, lng: 140.098846}
console.log('read map js file');
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
		document.getElementById('address').innerHTML = `<p>${text}</p>`;
		console.log('success');
		console.log(data);
	}).fail((data) => {
		console.log('fail');
		console.log(data);
	});

	// 座標を表示
	document.getElementById('lat').value = lat_lng.lat();
	document.getElementById('lng').value = lat_lng.lng();

	// マーカーを設置
	var marker = new google.maps.Marker({
	  position: lat_lng,
	  map: map
	});
}