module.exports = (robot) ->
	robot.hear /pils/i, (msg) ->
		msg.send "Pils? PILS? Humle, gutten min. Her i huset drikker vi IPA. Dobbel IPA."

	robot.respond /anbefal en god øl/i, (msg) ->
		msg.reply "IPA er godt."

	robot.respond /sjenk et brygg/i, (msg) ->
		width = Math.floor(Math.random() * 1800) + 200
		height = Math.floor(Math.random() * 1800) + 200
		msg.send "http://placebrew.com/brew/image/a/#{width}/#{height}"