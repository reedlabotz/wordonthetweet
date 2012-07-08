class Analyzer
  constructor: () ->
    @bagOfWords = new BagOfWordsClassifier('data/afinn-111-emo.json')
    @labeledNaiveBayes = new NaiveBayesClassifier('data/labeled.json')
    @emoticonNaiveBayes = new NaiveBayesClassifier('data/emoticon.json')
    @queue = []
    @running = false

  addToQueue: (tweet, callback) ->
    @queue.push {'tweet': tweet, 'callback': callback}
    if !@running
      @work()

  work: ->
    @running = true
    while @queue.length > 0
      job = @queue.shift()
      @bagOfWords.addToQueue job.tweet, (tweet, sentiment) => 
        @decideBest(tweet, sentiment, job.callback)
    @running = false

  decideBest: (tweet, sentiment, callback) ->
    tweet['sentiment'] = sentiment
    callback(tweet)

