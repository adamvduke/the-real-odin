# Description
#   Listens for 'deal with it' and posts deal with it dog
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None

module.exports = (robot) ->
  robot.hear /deal with it/i, (msg) ->
    msg.send "http://i.imgur.com/CupiM.gif"

