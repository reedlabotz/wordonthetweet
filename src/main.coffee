REFRESH_RATE = 10 * 1000

TWEETS_PER_PAGE = 10

searchTerm = 'hulu'

analyzer

analyzer = new Analyzer('AFINN-111-emo.txt')

lastMaxId = 0

grabTweets = () ->
	$.getJSON 'http://search.twitter.com/search.json?callback=?', { 
			'q': searchTerm, 
			'result_type': 'recent', 
			'since_id': lastMaxId,
			'rpp': TWEETS_PER_PAGE }, (data) ->
		processTweets data

processTweets = (data) ->
	console.log data
	lastMaxId = data['max_id_str']
	analyzer.addToQueue(tweet['text'], addToInterface) for tweet in data['results']
	setTimeout grabTweets, REFRESH_RATE

addToInterface = (tweet, sentiment) ->
	emoticon = if sentiment > 0 then ':)' else if sentiment < 0 then ':(' else ':|'
	$('body').prepend ("<p>" + emoticon + "   " + tweet + "</p>")

grabTweets()