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
    console.log $(@container).find("li").length
    console.log $(@container).find("li:gt(#{ MAX_TWEETS_SHOWN })").length
    $(@container).find("li:gt(#{ MAX_TWEETS_SHOWN })").remove()


  grabTweets: () ->
    @removeOld()
    $.getJSON 'http://search.twitter.com/search.json?callback=?', { 
      'q': @searchTerm, 
      'result_type': 'recent', 
      'lang': 'en',
      'since_id': @lastMaxId,
      'rpp': TWEETS_PER_PAGE }, (data) =>
        @processTweets data

  processTweets: (data) ->
    if data['error'] == undefined
      @lastMaxId = data['max_id_str']
      for tweet in data['results'].reverse()
        @analyzer.addToQueue(tweet['text'], tweet, (tweet, metadata, sentiment) => 
          @addToInterface(tweet, metadata, sentiment)) 
    @timer = setTimeout((() => @grabTweets()), @refreshRate)

  addToInterface: (tweet, metadata, sentiment) ->
    date = new Date(Date.parse(metadata['created_at']))
    emotion = if sentiment > 0 then 'positive' else if sentiment < 0 then 'negative' else 'neutral'
    switch emotion
      when 'positive' then @positiveCount++
      when 'negative' then @negativeCount++
      when 'neutral' then @neutralCount++  
    element = $(
      "<li class='tweet #{ emotion }'>
        <div class='title-bar'>
          <strong>@#{ metadata['from_user'] }</strong> 
          <em>
            <abbr class='timeago' title='#{ date.toISOString() }'>#{ date }</abbr>
          </em>
          </div>
        <img src='#{ metadata['profile_image_url'] }' class='avatar'>
        #{ tweet }
        <div class='clear'></div>
      </li>"
    ).hide().prependTo(@container + ' .tweets').slideDown(500);
    $(element).find("abbr.timeago").timeago();
