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

	robot.respond /(?=.*hvem)(?=.*dagens)(?=.*medarbeider)/i, (msg) ->
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
			"Dagens streber, dagens do-er, dagens uomtvistelige medarbeider, er... *#{staffOfTheDay}*!"
			"Ingen overraskelse det, vel? Det er *#{staffOfTheDay}*, selvfølgelig."
			"Er du spent? Tror du det er deg? Er du *#{staffOfTheDay}*? I så fall er du dagens medarbeider. Gratla."
		]
		robot.brain.set 'staffOfTheDay', { day: today.toDateString, staffName: staffOfTheDay }
		msg.send msg.random responsePhrases

	robot.respond /(?=.*liker)(?=.*ikke)(?=.*dagens)(?=.*medarbeider)/i, (msg) ->
		robot.brain.set 'staffOfTheDay', {}
		msg.reply "Enig. La meg tukle litt med dokumentene her..."

	robot.respond /quiz start/i, (msg) ->
		quiz = [
			{
				question: "Hva står IPA for?"
				answer: "India Pale Ale"
			}
			{
				question: "Hvilket år ble Ludens Reklamebyrå stiftet?"
				answer: "2001"
			}
			{
				question: "Risør er en fin by. I hvilket fylke ligger den?"
				answer: "Aust-Agder"
			}
		]

		selectedQuiz = quiz[ Math.floor( Math.random() * quiz.length ) ]
		quizObject = { username: msg.message.user.name, quiz: selectedQuiz }
		quizMem = robot.brain.get 'quiz'

		# Overwrite ongoing quiz
		if quizMem?
			for userQuiz, i in quizMem
				if userQuiz.username is msg.message.user.name
					quizMem.splice i, 1
					break

			quizMem.push quizObject
		else
			quizMem = [
				quizObject
			]

		robot.brain.set 'quiz', quizMem
		msg.send quizObject.quiz.question

	robot.respond /quiz svar (.*)/i, (msg) ->
		userAnswer = msg.match[1]
		quizMem = robot.brain.get 'quiz'
		quizStreakMem = robot.brain.get 'quizStreak'

		if !quizStreakMem?
			quizStreakMem = {}
			quizStreakMem[msg.message.user.name] = 0

		if quizMem?
			for userQuiz, i in quizMem
				if userQuiz.username is msg.message.user.name
					if userAnswer.toLowerCase() is userQuiz.quiz.answer.toLowerCase()
						quizMem.splice i, 1
						robot.brain.set 'quiz', quizMem
						quizStreakMem[userQuiz.username] += 1
						msg.send "*#{userAnswer}* er riktig. Grattis. Du er flink, ass."
					else
						quizStreakMem[msg.message.user.name] = 0
						msg.send "*#{userAnswer}* er feil. Prøv igjen. Douche."

					robot.brain.set 'quizStreak', quizStreakMem

					return

		msg.send "Hva er det du prøver å svare på, egentlig?"

	robot.respond /quiz skår (.*)/i, (msg) ->
		if msg.match[1]
			username = msg.match[1]
		else
			username = msg.message.user.name

		quizStreakMem = robot.brain.get 'quizStreak'

		if quizStreakMem[username]?
			msg.send "*#{username}* har foreløpig klart å svare riktig *#{quizStreakMem[username]}* ganger på rad."
			return

		msg.send "*#{username}* har ikke prøvd quizzen enda. For dum til å tørre, tipper jeg."		







