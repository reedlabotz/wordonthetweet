REFRESH_RATE = 10 * 1000

TWEETS_PER_PAGE = 100

searchTerm = ''

analyzer = new Analyzer('AFINN-111-emo.txt')

lastMaxId = 0

timeOut = null

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
	$('#results').prepend ("<p>" + emoticon + "   " + tweet + "</p>")

$(document).ready -> 
	$('#searchButton').click () ->
		clearTimeout(timeOut)
		$('#results').html('')
		searchTerm = $("#searchTerm").val()
		grabTweets()