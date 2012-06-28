REFRESH_RATE = 10 * 1000

TWEETS_PER_PAGE = 100

searchTerm = ''

analyzer = new Analyzer('AFINN-111-emo.txt')

lastMaxId = 0

timeOut = null

positiveCount = 0;

negativeCount = 0;

neutralCount = 0;

grabTweets = () ->
	$.getJSON 'http://search.twitter.com/search.json?callback=?', { 
			'q': searchTerm, 
			'result_type': 'recent', 
			'since_id': lastMaxId,
			'rpp': TWEETS_PER_PAGE }, (data) ->
		processTweets data

processTweets = (data) ->
	if data['error'] != undefined
		return timeOut = setTimeout grabTweets, REFRESH_RATE
	lastMaxId = data['max_id_str']
	for tweet in data['results']
		analyzer.addToQueue(tweet['text'], tweet, addToInterface) if tweet['iso_language_code'] == "en"
	timeOut = setTimeout grabTweets, REFRESH_RATE

addToInterface = (tweet, metadata, sentiment) ->
	emotion = if sentiment > 0 then 'positive' else if sentiment < 0 then 'negative' else 'neutral'
	switch emotion
		when 'positive' then positiveCount++
		when 'negative' then negativeCount++
		when 'neutral' then neutralCount++
	$("<div class='tweet " + emotion + "''>" + 
	  "<img src='" + metadata['profile_image_url'] + "' class='avatar'>" +
	  "<strong>@" + metadata['from_user'] + "</strong><br>" + 
	  tweet + "<div class='clear'></div></div>").hide().prependTo('#results').slideDown("slow");

$(document).ready -> 
	$('#searchButton').click () ->
		clearTimeout(timeOut)
		$('#results').html('')
		searchTerm = $("#searchTerm").val()
		grabTweets()