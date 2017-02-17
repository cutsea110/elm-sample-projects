var https = require('https');
var express = require('express');
var bodyParser = require('body-parser');
var socketio = require('socket.io');
var fs = require('fs');
var twit = require('twit');

// Twitter Streaming API
var twitter = twit({
    consumer_key: 'd7Ek9KBltiMCtwVycyXb2rKJZ',
    consumer_secret: 'DDcYqFLB3OQv1uwusBy7voE0t3nGtYQNEX9chOwUtcJooUTwYp',
    access_token: '5919082-p5A8cZIjZfxMaXS3lEi2e96cdGMCzr6cu7kk0FmD1Y',
    access_token_secret: 'Mz5pX9ufU987KINol7V9x79kC3Kmp5k1nH1ZntZqdA414'
});

var stream = null;

function refreshStream(loc) {
    var lat = loc.latitude, lng = loc.longitude,
	option = { locations : [(lng-0.01).toString(),
		                (lat-0.01).toString(),
		                (lng+0.01).toString(),
		                (lat+0.01).toString()
		               ]
                 };
    console.log('option', option);
    stream = twitter.stream('statuses/filter', option);
    stream.on('tweet', function(tweet) {
	// simple
	console.log(tweet.user.name+'@'+tweet.user.screen_name+' < '+tweet.text);
	// verbose
	//console.log(tweet);
	if (tweet.coordinates) {
	    io.sockets.emit('tweet', tweet);
	}
    });
    console.log(stream);
    console.log('************************************');
    console.log(' R E S T A R T: ' + loc.latitude + "," + loc.longitude);
    console.log('************************************');
};

//var option = { locations: [ '-122.75', '36.8', '-121.75', '37.8' ]};
//var option = { locations: [ '139.0', '35.0', '140.0', '36.0' ]};
//var option = { locations: [ '123.283201','24.117224','150.625329','46.242887' ]};
refreshStream({latitude: 35.69, longitude: 139.72});

// Returns an Express server
var app = express();
// CORS
app.use(function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});
// JSON body parser set up
app.use(bodyParser.urlencoded({
    extended: true
}));
app.use(bodyParser.json());
app.post('/move-to', function(req, res) {
    console.log('Marker moved', req.body);

    stream.stop();
    refreshStream(req.body);

    res.send('POST request ok');
});

var server = https.createServer({ key: fs.readFileSync('./src/server_key.pem'),
				  cert: fs.readFileSync('./src/server_crt.pem')
				}
				, app);

var io = socketio.listen(server, {log : false});
server.listen(4000);
console.log('port:4000 listening ...');
