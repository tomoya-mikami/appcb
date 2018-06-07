// google mapの初期位置
var defaultPostion = {lat: 36.090707, lng: 140.098846}
var map = '';
marker = [];
var disasters;

// 災害情報表示用のデータを持ってくる
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

function initMap() {
	// Create a map object and specify the DOM element for display.
	map = new google.maps.Map(document.getElementById('map'), {
		center: defaultPostion,
		zoom: 14
  });
  
  getPostion();
}

function set_marker(_lat, _lng, _icon, _map) {
    return new google.maps.Marker({ position: {lat: _lat, lng: _lng}, icon: _icon, map: _map });
}

function getPostion() {
  $.ajax({
    type: "Get",
    url: location.protocol + "/position/index/",
    dataType: 'json',
  }).done(function(data){
    console.log(data);
    var disaster_id = 0;
    data['results'].forEach(element => {
      var disaster_icon = null;
      if (element['disaster_id']) {
        disaster_id = element['disaster_id'] - 1;
        disaster_icon = disasters[disaster_id]['image']['url'];
      } 
      set_marker(Number(element['latitude']), Number(element['longitude']), disaster_icon, map);
    });
  }).fail(function(jqXHR, textStatus, errorThrown){
    console.log(jqXHR);
    console.log(textStatus);
    console.log(errorThrown);
  })
}