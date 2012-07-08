class Tweet
  constructor: (metadata)->
    @text = metadata['text']
    @clean_text = clean(@text)
    @username = metadata['from_user'] if metadata['from_user']
    @created_at = metadata['created_at'] if metadata['created_at']
    @profile_url = metadata['profile_image_url'] if metadata['profile_image_url']
    @sentiment = if metadata['sentiment'] then metadata['sentiment'] else null

  tokenize: ->
    words = @clean_text.split /\s+/g
    output = words
    lastW = null
    for w in words
      if w != null
        output.push ("#{ lastW } #{ w}")
      lastW = w
    return output

  clean = (text) ->
    text = text.toLowerCase()

    removeHTMLEncode = /&[a-z]+;/g
    text = text.replace removeHTMLEncode, ""

    removeApostrophe = /([a-z])'([a-z])/g
    text = text.replace removeApostrophe, "$1$2"
    
    removeUrls = /(((f|ht){1}tp(s)?:\/\/)[-a-zA-Z0-9@:%_\+.~?&\/\/=]+)/
    text = text.replace removeUrls, ""
    
    removeHandlesAndHashTags = /@[a-z0-9]+|#[a-z0-9]+/g
    text = text.replace removeHandlesAndHashTags, ""
    
    letterPuncuationLetter = /([a-z])([\.,-\/\#!?$%\^&\*;:{}=\-_`"'~()])([a-z ])/g
    text = text.replace letterPuncuationLetter, "$1 $2 $3"

    puncuationLetter = /([\.,-\/\#!?$%\^&\*;:{}=\-_`"'~()])([a-z])/g
    text = text.replace puncuationLetter, "$1 $2"

    letterPunctuation = /([a-z])([\.,-\/\#!?$%\^&\*;:{}=\-_`"'~()])/g
    text = text.replace letterPunctuation, "$1 $2"

    doubleLetter = /([a-z])\1+/g
    text = text.replace doubleLetter, "$1$1"

    text = text.trim()

    return text