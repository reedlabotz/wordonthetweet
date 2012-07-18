class StreamView
  constructor: () ->

  removeOld: () ->
    $(@container).find("li:gt(#{ app.Constants.MAX_TWEETS_SHOWN })").remove()
  