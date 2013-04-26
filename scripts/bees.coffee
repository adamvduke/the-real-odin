# Description:
#   Bees are insane
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   bees - Oprah at her finest, or a good way to turn the fans on coworkers machines
#
# Author:
#   atmos

module.exports = (robot) ->
  # if this gets posted too often, robot.hear can be changed to robot.respond
  # so that it requires a 'robot: bees' command to post the gif
  robot.hear /bee+s?\b/i, (message) ->
    message.send "http://i.imgur.com/qrLEV.gif"
