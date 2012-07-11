class Stream
  constructor: (analyzer, searchTerm, refreshRate, container) ->
    @searchTerm = searchTerm
    @refreshRate = refreshRate
    @analyzer = analyzer
    @container = container

    @lastMaxId = 0
    @positiveCount = 0;
    @negativeCount = 0;
    @neutralCount = 0;

    @timer = null

    @grabTweets()

  setRefreshRate: (refreshRate) ->
    @refreshRate = refreshRate

  destroy: () ->
    $(@container).remove()
    clearTimeout(@timer)

  ## Private functions ## 

  removeOld: () ->
    $(@container).find("li:gt(#{ app.Constants.MAX_TWEETS_SHOWN })").remove()


  grabTweets: () ->
    @removeOld()
    $.getJSON 'http://search.twitter.com/search.json?callback=?', { 
      'q': @searchTerm, 
      'result_type': 'recent', 
      'lang': 'en',
      'since_id': @lastMaxId,
      'rpp': app.Constants.TWEETS_PER_PAGE }, (data) =>
        @processTweets data

  processTweets: (data) ->
    if data['error'] == undefined
      @lastMaxId = data['max_id_str']
      for tweet in data['results'].reverse()
        t = new app.gui.Tweet(tweet)
        @analyzer.addToQueue(t, (tweet_out) => 
          @addToInterface(tweet_out)) 
    @timer = setTimeout((() => @grabTweets()), @refreshRate)

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
    $(element).find("abbr.timeago").timeago();
