class Classifier
  constructor: () ->
    @data = null
    @ready = false

  loadData: (path) ->
    $.getJSON path, (data) =>
      @data = data
      @ready = true
      $(@).trigger app.lib.Classifier.Events.Ready, @

  exportData: (path) ->
    $.post path, {'data': @data}, () ->


  classify: () ->
    return "Not implemented"

  @Events = {
    Ready: "Classifier.Events.Ready"
  }
