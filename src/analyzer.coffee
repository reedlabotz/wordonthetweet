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

  addToQueue: (text, metadata, callback) ->
    console.log "add",callback
    @queue.push {'text': text, 'metadata': metadata, 'callback': callback}
    if(!@running && @ready) 
      @work()


  ## Private functions ##

  analyze: (text, metadata, callback) ->
    #console.log "analyze",callback
    words = text.toLowerCase().split /\W+/
    sentiments = []
    for word in words
      if @afinn[word] != undefined
        sentiments.push @afinn[word]

    sum = 0
    for s in sentiments
      sum += s
    sqrt = Math.sqrt sentiments.length
    callback text, metadata, (sum/sqrt)

  work: ->
    @running = true
    while @queue.length > 0
      job = @queue.shift()
      @analyze(job.text, job.metadata, job.callback)
    @running = false
