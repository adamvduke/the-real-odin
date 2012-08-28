module.exports = (robot) ->
  robot.hear /is this real life/i, (msg) ->
    msg.send "http://i.imgur.com/pobIY.jpg"
