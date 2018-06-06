// google mapの初期位置
var defaultPostion = {lat: 36.090707, lng: 140.098846}
var map = '';
marker = []
function initMap() {
	// Create a map object and specify the DOM element for display.
	map = new google.maps.Map(document.getElementById('map'), {
		center: defaultPostion,
		zoom: 14
  });
  
  getPostion();
}

function set_marker(_lat, _lng, _map) {
    return new google.maps.Marker({ position: {lat: _lat, lng: _lng}, map: _map });
}

function getPostion() {
  $.ajax({
    type: "Get",
    url: location.protocol + "/position/index/",
    dataType: 'json',
  }).done(function(data){
    console.log(data);
    data['results'].forEach(element => {
      set_marker(Number(element['latitude']), Number(element['longitude']), map);
    });
  }).fail(function(jqXHR, textStatus, errorThrown){
    console.log(jqXHR);
    console.log(textStatus);
    console.log(errorThrown);
  })
}