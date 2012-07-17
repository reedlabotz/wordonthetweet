#<< app/lib/classifier

class BagOfWordsClassifier extends app.lib.Classifier
  constructor: () ->
    super

  classify: (text) ->
    words = tweet.words()
    
    sum = 0
    count = 0
    for word in words
      if @afinn[word] != undefined
        sum += @data[word]
        count++

    sqrt = Math.sqrt count
    value = (sum/sqrt)
    sentiment = if value > 0 then 'p' else if value < 0 then 'n' else null
    return sentiment