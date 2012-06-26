class Analyzer
  constructor: (dictionary_path) ->
    @ready = false
    @afinn = {}
    caller = @
    $.get dictionary_path, (data) -> 
      lines = data.split '\n'
      for line in lines 
        [word, value] = line.split '\t'
        caller.afinn[word] = parseInt value
      caller.ready = true

  analyze: (text) ->
    words = text.toLowerCase().split /\W+/
    sentiments = []
    for word in words
      if @afinn[word] != undefined
        sentiments.push @afinn[word]

    sum = sentiments.reduce (t, s) -> t + s
    sqrt = Math.sqrt sentiments.length
    console.log sum, sqrt, sum/sqrt
    sum/sqrt