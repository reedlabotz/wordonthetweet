class Classifier
  constructor: () ->
    @data = null

  loadData: (path) ->
    $.getJSON path, (data) =>
      @data = data

  exportData: (path) ->
    $.post path, {'data': @data}, () ->


  classify: () ->
    return "Not implemented"
