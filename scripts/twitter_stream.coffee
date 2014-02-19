# Description
#   Filters out Twitter stream and displays tweets
#
# Dependencies:
#   "twit": "1.1.6"
#
# Configuration:
#   HUBOT_TWITTER_STREAM_CONSUMER_KEY
#   HUBOT_TWITTER_STREAM_CONSUMER_SECRET
#   HUBOT_TWITTER_STREAM_ACCESS_TOKEN
#   HUBOT_TWITTER_ACCESS_TOKEN_SECRET
#   HUBOT_TWITTER_STREAM_FILTERS
#   HUBOT_TWITTER_STREAM_ROOM_IDS
#
# Commands:
#   hubot start twitter stream - Starts a stream and listens for tweets containing HUBOT_TWITTER_STREAM_FILTERS
#   hubot stop twitter stream - Disconnects from Twitter stream
#
# Notes:
#   Only one stream can be active per IP address at the same time. The filter operates on the <track> parameter of
#   Twitter statuses/filter endpoint. See https://dev.twitter.com/docs/api/1.1/post/statuses/filter
#   for additional details.
#
# Author:
#   matteoagosti

Twit = require "twit"
config = 
  consumer_key: process.env.HUBOT_TWITTER_STREAM_CONSUMER_KEY
  consumer_secret: process.env.HUBOT_TWITTER_STREAM_CONSUMER_SECRET
  access_token: process.env.HUBOT_TWITTER_STREAM_ACCESS_TOKEN
  access_token_secret: process.env.HUBOT_TWITTER_ACCESS_TOKEN_SECRET

default_filters = process.env.HUBOT_TWITTER_STREAM_FILTERS

stream_rooms = []
for room_id in process.env.HUBOT_TWITTER_STREAM_ROOM_IDS.split(',')
  stream_rooms.push(parseInt(room_id))

current_room_id = (msg) ->
  msg.message.room

stream = null

module.exports = (robot) ->

  configure_stream = (msg) ->
    twit = new Twit config
    stream = twit.stream('statuses/filter', track: default_filters)
    stream.on "tweet", (tweet) ->
      unless tweet.text.indexOf('RT ') == 0
        msg.send "https://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id_str}"
    stream.on "disconnect", (disconnectMessage) ->
      stream = null
      msg.send "I've been disconnected from the Twitter stream. Apparently the reason is: #{disconnectMessage}"
    stream.on "reconnect", (request, response, connectInterval) ->
      msg.send "I'll reconnect to Twitter stream in #{connectInterval}ms"
    stream

  setup_default_stream = (msg) ->
    unless config.consumer_key && config.consumer_secret && config.access_token && config.access_token_secret && default_filters
      msg.send 'Please set the
        HUBOT_TWITTER_STREAM_CONSUMER_KEY,
        HUBOT_TWITTER_STREAM_CONSUMER_SECRET,
        HUBOT_TWITTER_STREAM_ACCESS_TOKEN,
        HUBOT_TWITTER_ACCESS_TOKEN_SECRET,
        and HUBOT_TWITTER_STREAM_FILTERS
        environment variables.'
      return
    if stream
      msg.send "I'm listening for #{default_filters} in room #{current_room_id(msg)}."
    else
      stream = configure_stream(msg)
      msg.send "Configuring the default twitter stream with #{default_filters} for room id #{current_room_id(msg)}."

  robot.respond /start twitter stream/i, (msg) ->
    if current_room_id(msg) in stream_rooms
      setup_default_stream(msg)

  robot.enter (msg) ->
    if current_room_id(msg) in stream_rooms
      setup_default_stream(msg)

  robot.leave (msg) ->
    if current_room_id(msg) in stream_rooms
      setup_default_stream(msg)

  robot.respond /stop twitter stream/i, (msg) ->
    if current_room_id(msg) in stream_rooms
      if stream
        msg.send "Disconnecting stream for room #{current_room_id(msg)}."
        stream.stop()
        stream = null
      msg.send "Ok, I'm now disconnected from the stream."

