# Description:
#   David after the dentist
#
# Commands:
#   Listens for "is this real life" and posts a funny picture.

module.exports = (robot) ->
  robot.hear /is this real life/i, (msg) ->
    msg.send "http://i.imgur.com/pobIY.jpg"
