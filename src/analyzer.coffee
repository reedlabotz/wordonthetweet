class Analyzer
  constructor: (dictionary_path) ->
    @afinn = {}
    $.get dictionary_path, (err, r, body) -> 
      lines = body.split '\n'
      for line in lines 
        do (line) -> 
          [word, value] = line.split '\t'
          afinn[word] = value
      console.log @affinn

  analyze: (text) ->
    words = text.toLowerCase().split /\W+/
    for word in words
      do (word) ->
        console.log word
    console.log 'end'