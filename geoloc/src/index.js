'use strict';

require('ace-css/css/ace.css');
require('font-awesome/css/font-awesome.css');

// index.html,ssl認証鍵がdistにコピーされるようにRequireする
require('./index.html');

var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

// .embed()はオプションの第二引数を取り、プログラム開始に必要なデータを与えられる。たとえばuserIDや何らかのトークンなど
var app = Elm.Main.embed(mountNode);

var mapDiv = document.getElementById('map');
var mapOptions = {
    zoom: 13,
    center: new google.maps.LatLng(0, 0)
};

var gmap = new google.maps.Map(mapDiv, mapOptions);

var routeCoordinates = new google.maps.MVCArray();
var routePath = new google.maps.Polyline({
    path: routeCoordinates,
    strokeColor: "#FF0000",
    strokeOpacity: 1.0,
    strokeWeight: 2
});
routePath.setMap(gmap);

var markerList = new google.maps.MVCArray();
app.ports.markerMove.subscribe(function(loc) {
    console.log("received", loc);
    var myLatlng = new google.maps.LatLng(loc);
    gmap.setCenter(loc);
    
    markerList.forEach(function (mkr, idx) {
	mkr.setMap(null);
    });
    var myMarker = new google.maps.Marker({
	position: loc,
	title: loc.msg,
	icon: new google.maps.MarkerImage(
            'lazy.png',                   // url
            new google.maps.Size(63,63),  // size
            new google.maps.Point(0,0),   // origin
            new google.maps.Point(32,32), // anchor
            new google.maps.Size(63,63)   // scaledSize
	)
    });
    myMarker.setMap(gmap);
    markerList.push(myMarker);

    routeCoordinates.push(myLatlng);
    console.log("routes", routeCoordinates);
});

// subscribe twitter streaming
var tweetList = new google.maps.MVCArray();
var twtext = require('twitter-text');
var twemoji = require('twemoji');
var zIndex = 1;

var io = require('socket.io-client')('https://localhost:4000');
console.log('io', io);
var socket = io.connect();
console.log('socket', socket);
socket.on('tweet', function(data) {
    console.log('tweet', data);
    tweetList.forEach(function (tw, idx) {
	if (tw.userId == data.user.id) {
	    tw.setMap(null);
	    tweetList.removeAt(idx);
	    console.log('removed marker', data.user.name+'@'+data.user.screen_name);
	}
    });
    var loc = { lat: data.coordinates.coordinates[1],
		lng: data.coordinates.coordinates[0]
	      };
    var myLatlng = new google.maps.LatLng(loc);
    var myMarker = new google.maps.Marker({
	position: myLatlng,
	title: data.user.description,
	icon: data.user.profile_image_url,
	userId: data.user.id,
	zIndex: zIndex++
    });
    myMarker.setMap(gmap);
    tweetList.push(myMarker);
    var myMsg = new google.maps.InfoWindow({
	content: twemoji.parse(twtext.autoLink(twtext.htmlEscape(data.text)),{size:72})
    });
    myMsg.open(gmap, myMarker);
    setTimeout(function(){ myMsg.close(); }, 5000);
    google.maps.event.addListener(myMarker, "click", function(e){
	myMsg.open(gmap, myMarker);
    });
});

