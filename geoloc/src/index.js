'use strict';

require('ace-css/css/ace.css');
require('font-awesome/css/font-awesome.css');

// index.htmlがdistにコピーされるようにRequireする
require('./index.html');

const Twit = require('twit');

var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

// .embed()はオプションの第二引数を取り、プログラム開始に必要なデータを与えられる。たとえばuserIDや何らかのトークンなど
var app = Elm.Main.embed(mountNode);

var mapDiv = document.getElementById('map');
var myLatlng = new google.maps.LatLng(0, 0);
var mapOptions = {
    zoom: 18,
    center: myLatlng
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
