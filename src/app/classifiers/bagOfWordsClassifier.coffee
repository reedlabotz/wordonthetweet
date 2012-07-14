class BagOfWordsClassifier
  constructor: (dictionary_path) ->
    @afinn = {}
    $.getJSON dictionary_path, (data) => 
      @afinn = data

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
    sentiment = if value > 0 then 'p' else if value < 0 then 'n' else null
    callback tweet, sentiment

  work: ->
    @running = true
    while @queue.length > 0
      job = @queue.shift()
      @analyze(job.tweet, job.callback)
    @running = false
