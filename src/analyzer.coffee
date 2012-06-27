class Analyzer
  constructor: (dictionary_path) ->
    @afinn = {}
    @queue = []
    @running = false
    @ready = false
    caller = @
    $.get dictionary_path, (data) -> 
      lines = data.split '\n'
      for line in lines 
        [word, value] = line.split '\t'
        caller.afinn[word] = parseInt value
      caller.ready = true
      caller.work()


  analyze: (text, callback) ->
    words = text.toLowerCase().split /\W+/
    sentiments = []
    for word in words
      if @afinn[word] != undefined
        sentiments.push @afinn[word]

    sum = 0
    for s in sentiments
      sum += s
    sqrt = Math.sqrt sentiments.length
    callback text, (sum/sqrt)

  addToQueue: (text, callback) ->
    @queue.push {'text': text, 'callback': callback}
    if(!@running && @ready) 
      @work()

  work: ->
    @running = true
    while @queue.length > 0
      job = @queue.shift()
      @analyze(job.text, job.callback)
    @running = false
