class BagOfWordsClassifier
  constructor: (dictionary_path) ->
    @afinn = {}
    @queue = []
    @running = false
    @ready = false
    $.getJSON dictionary_path, (data) => 
      @afinn = data
      @ready = true
      @work()

  addToQueue: (tweet, callback) ->
    @queue.push {'tweet': tweet, 'callback': callback}
    if(!@running && @ready) 
      @work()


  ## Private functions ##

  analyze: (tweet, callback) ->
    words = tweet.words()
    sentiments = []
    for word in words
      if @afinn[word] != undefined
        sentiments.push @afinn[word]

    sum = 0
    for s in sentiments
      sum += s
    sqrt = Math.sqrt sentiments.length
    value = (sum/sqrt)
    sentiment = if value > 0 then 'positive' else if value < 0 then 'negative' else 'neutral'
    callback tweet, sentiment

  work: ->
    @running = true
    while @queue.length > 0
      job = @queue.shift()
      @analyze(job.tweet, job.callback)
    @running = false
