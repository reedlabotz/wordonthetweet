class StreamController
  constructor: () ->

  grabTweets: () ->
    @removeOld()
    $.getJSON 'http://search.twitter.com/search.json?callback=?', { 
      'q': @searchTerm, 
      'result_type': 'recent', 
      'lang': 'en',
      'since_id': @lastMaxId,
      'rpp': app.Constants.TWEETS_PER_PAGE }, (data) =>
        @processTweets data

  addToInterface: (tweet) ->
    date = new Date(Date.parse(tweet['created_at']))
    switch tweet['sentiment']
      when 'positive' then @positiveCount++
      when 'negative' then @negativeCount++
      when 'neutral' then @neutralCount++  
    element = $("""
      <li class='tweet #{ tweet['sentiment'] }'>
        <div class='title-bar'>
          <strong>@#{ tweet['username'] }</strong> 
          <em>
            <abbr class='timeago' title='#{ date.toISOString() }'>#{ date }</abbr>
          </em>
          </div>
        <img src='#{ tweet['profile_url'] }' class='avatar'>
        #{ tweet['text'] }
        <div class='clear'></div>
      </li>
    """).hide().prependTo(@container + ' .tweets').slideDown(500);
    