# sudo apt install npm
# ref.) https://devcenter.heroku.com/articles/heroku-cli
# sudo apt install heroku
$ npm i -S
$ node_modules/foreman/nf.js start
# Access to https://localhost:3000 by web browser.

# Troubleshooting
# If you look at net::ERR_INSECURE_RESPONSE error occuring in google-chrome,
# Input `about:flags` in address bar, and
# Enable `#allow-insecure-localhost` and restart google-chrome.

## ref.) https://kijtra.com/article/nodejs-twitter-stream/

# Test location change
$ curl --insecure -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"latitude": 35.000, "longitude": 139.000}' https://localhost:4000/move-to

