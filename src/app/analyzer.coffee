#<< app/classifiers/bagOfWordsClassifier
#<< app/classifiers/naiveBayesClassifier

class Analyzer
  constructor: () ->
    @bagOfWords = new app.classifiers.BagOfWordsClassifier('data/afinn-111-emo.json')
    @labeledNaiveBayes = new app.classifiers.NaiveBayesClassifier('data/labeled.json')
    @emoticonNaiveBayes = new app.classifiers.NaiveBayesClassifier('data/emoticon.json')
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
      async.parallel {
          emoticon: (callback) => @emoticonNaiveBayes.classify job.tweet, callback,
          bag: (callback) => @bagOfWords.addToQueue job.tweet, callback,
          
          labeled: (callback) => @labeledNaiveBayes.classify job.tweet, callback
        },
        (tweet, sentiments) =>
          console.log sentiments
          @decideBest(tweet, sentiments, job.callback)
      
    @running = false

  decideBest: (tweet, sentiments, callback) ->
    console.log sentiments
    lookup = {null: 'neutral', 'p': 'positive', 'n': 'negative'}
    number = {null: 0, 'p': 1, 'n': -1}
    for l, v of sentiments
      console.log l, v
    sum = number[sentiments['bag']] + number[sentiments['emoticon']] + number[sentiments['labeled']]
    console.log tweet, sentiments, sum

    tweet['sentiment'] = lookup[sentiments['emoticon']]
    callback(tweet)

