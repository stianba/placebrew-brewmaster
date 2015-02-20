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

	robot.respond /hvem er dagens medarbeider/i, (msg) ->
		employees = [
			"Kjerstin"
			"Tore"
			"Tor Alf"
			"Thord"
			"Tone"
			"Susanne"
			"Annette"
			"John"
			"Kristian"
			"Kine"
			"Stian"
			"Jon"
			"Line"
			"Karl"
		]

		today = new Date()
		anotherDay = null
		staffOfTheDayMem = robot.brain.get 'staffOfTheDay'
		staffOfTheDay = employees[ Math.floor( Math.random() * employees.length ) ]

		if staffOfTheDayMem?
			anotherDay = staffOfTheDayMem.day
			staffOfTheDay = staffOfTheDayMem.staffName if today.toDateString is anotherDay

		responsePhrases = [
			"Dagens streber, dagens do-er, dagens uomtvistelige medarbeider, er... *Trommevirvel* #{staffOfTheDay}!"
			"Ingen overraskelse det, vel? Det er #{staffOfTheDay}, selvfølgelig."
			"Er du spent? Tror du det er deg? Er du #{staffOfTheDay}? I så fall er du dagens medarbeider. Gratla."
		]
		robot.brain.set 'staffOfTheDay', { day: today.toDateString, staffName: staffOfTheDay }
		msg.send msg.random responsePhrases

	robot.respond /jeg liker ikke dagens medarbeider/i, (msg) ->
		robot.brain.set 'staffOfTheDay', {}
		msg.reply "Enig. La meg tukle litt med dokumentene her..."


		