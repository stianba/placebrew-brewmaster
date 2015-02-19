module.exports = (robot) ->
	robot.hear /pils/i, (msg) ->
		msg.send "Pils? PILS? Humle, gutten min. Her i huset drikker vi IPA. Dobbel IPA."

	robot.respond /anbefal en god øl/i, (msg) ->
		msg.reply "IPA er godt."

	robot.respond /sjenk et brygg/i, (msg) ->
		width = Math.floor(Math.random() * 1800) + 200
		height = Math.floor(Math.random() * 1800) + 200
		msg.send "http://placebrew.com/brew/image/a/#{width}/#{height}"

	robot.respond /sjenk en (.*)/i, (msg) ->
		brewStyle = msg.match[1]
		url = "http://placebrew.com/brew/image/type/beer/#{brewStyle}"
		robot.http(url)
			.header('Accept', 'image/jpg')
    		.get() (err, res, body) ->
    			if res.statusCode isnt 200
    				msg.send "Sorry. Vi er tomme for #{brewStyle}. Det har vært så himla populært denne uka."

    			msg.send url