var http = require('http');
var express = require('express');
var socketio = require('socket.io');
var twit = require('twit');

// Returns an Express server
var app = express();
var server = http.createServer(app);

var io = socketio.listen(server, {log : false});
server.listen(4000);
console.log('port:4000 listening ...');

// Twitter Streaming API
var twitter = twit({
    consumer_key: 'd7Ek9KBltiMCtwVycyXb2rKJZ',
    consumer_secret: 'DDcYqFLB3OQv1uwusBy7voE0t3nGtYQNEX9chOwUtcJooUTwYp',
    access_token: '5919082-p5A8cZIjZfxMaXS3lEi2e96cdGMCzr6cu7kk0FmD1Y',
    access_token_secret: 'Mz5pX9ufU987KINol7V9x79kC3Kmp5k1nH1ZntZqdA414'
});

//var option = { locations: [ '-122.75', '36.8', '-121.75', '37.8' ]};
//var option = { locations: [ '139.0', '35.0', '140.0', '36.0' ]};
//var option = { locations: [ '123.283201','24.117224','150.625329','46.242887' ]};
var option = { locations: [ '139.71','35.68','139.73','35.72' ]};
var stream = twitter.stream('statuses/filter', option);
console.log('stream', stream);
stream.on('tweet', function(tweet) {
    console.log(tweet);
    if (tweet.coordinates) {
	io.sockets.emit('tweet', tweet);
    }
});
