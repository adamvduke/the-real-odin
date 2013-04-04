module.exports = (robot) ->
  robot.hear /deal with it/i, (msg) ->
    msg.send "http://i.imgur.com/CupiM.gif"

