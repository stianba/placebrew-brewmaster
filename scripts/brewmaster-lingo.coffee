module.exports = (robot) ->
	robot.hear /pils/i, (msg) ->
		msg.send "Pils? PILS? Humle, gutten min. Her i huset drikker vi IPA. Dobbel IPA."

	robot.respond /anbefal en god øl/i, (msg) ->
		msg.reply "IPA er godt."

	robot.respond /anbefal en god kaffe/i, (msg) ->
		msg.reply "Alt annet en ren og pur svart kaffe er for tullinger. Mer gyllenbrun enn svart, egentlig. Supreme Roastworks er godt. Velg en etiopisk."

	robot.respond /sjenk et brygg/i, (msg) ->
		width = Math.floor(Math.random() * 1800) + 200
		height = Math.floor(Math.random() * 1800) + 200
		msg.send "http://placebrew.com/brew/image/a/#{width}/#{height}"

	robot.respond /sjenk en (.*)/i, (msg) ->
		brewStyle = msg.match[1]
		url = "http://placebrew.com/brew/image/type/beer/#{brewStyle}"

		if brewStyle is 'kaffe'
			url = "http://placebrew.com/brew/image/type/coffee"
		else if brewStyle is 'øl'
			url = "http://placebrew.com/brew/image/type/beer"

		robot.http(url)
    	.get() (err, res, body) ->
			if res.statusCode isnt 200
				msg.send "Sorry. Vi er tomme for #{brewStyle}. Det har vært så himla populært denne uka."
				return

			msg.send url