class StreamModel
  constructor: (searchTerm, refreshRate) ->
    @searchTerm = searchTerm
    @refreshRate = refreshRate

    @lastMaxId = 0
    @positiveCount = 0;
    @negativeCount = 0;
    @neutralCount = 0;

    @timer = null

  setRefreshRate: (@refreshRate) ->

  destroy: () ->
    clearTimeout(@timer)

  ## Private functions ## 

  processTweets: (data) ->
    if data['error'] == undefined
      @lastMaxId = data['max_id_str']
      for tweet in data['results'].reverse()
        t = new app.gui.Tweet(tweet)
        @analyzer.addToQueue(t, (tweet_out) => 
          @addToInterface(tweet_out)) 
    @timer = setTimeout((() => @grabTweets()), @refreshRate)
