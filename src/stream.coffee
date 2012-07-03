class Stream
  constructor: (analyzer, searchTerm, refreshRate, results) ->
    @searchTerm = searchTerm
    @refreshRate = refreshRate
    @analyzer = analyzer
    @results = results

    @lastMaxId = 0
    @positiveCount = 0;
    @negativeCount = 0;
    @neutralCount = 0;

    @grabTweets()

  setRefreshRate: (refreshRate) ->
    @refreshRate = refreshRate


  ## Private functions ## 

  grabTweets: () ->
    caller = @
    $.getJSON 'http://search.twitter.com/search.json?callback=?', { 
      'q': @searchTerm, 
      'result_type': 'recent', 
      'since_id': @lastMaxId,
      'rpp': TWEETS_PER_PAGE }, (data) ->
        caller.processTweets data

  processTweets: (data) ->
    caller = @
    if data['error'] == undefined
      @lastMaxId = data['max_id_str']
      for tweet in data['results']
        @analyzer.addToQueue(tweet['text'], tweet, (tweet, metadata, sentiment) => @addToInterface(tweet, metadata, sentiment)) if tweet['iso_language_code'] == "en"
    setTimeout () -> 
      caller.grabTweets() 
    , caller.refreshRate

  addToInterface: (tweet, metadata, sentiment) ->
    emotion = if sentiment > 0 then 'positive' else if sentiment < 0 then 'negative' else 'neutral'
    switch emotion
      when 'positive' then @positiveCount++
      when 'negative' then @negativeCount++
      when 'neutral' then @neutralCount++
    $("<div class='tweet " + emotion + "''>" + 
      "<img src='" + metadata['profile_image_url'] + "' class='avatar'>" +
      "<strong>@" + metadata['from_user'] + "</strong><br>" + 
      tweet + "<div class='clear'></div></div>").hide().prependTo(@results).slideDown("slow");
