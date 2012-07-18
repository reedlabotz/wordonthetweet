#<< app/models/analyzer_model

class OptionsModel
  constructor: (analyzer) ->
    @analyzer_model = new app.models.AnalyzerModel()
    $(@analyzer_model).on app.models.AnalyzerModel.Events.Ready, (event, object) => @ready()

    @nextStreamId = 0

    @init()

  init: () ->
    $(app.Constants.OPTIONS_CONTAINER).modal({
      backdrop: 'static',
      keyboard: false,
      show: true
    })
    $(app.Constants.OPTIONS_ADD_BTN).click () => @addColumn()
    $(app.Constants.OPTIONS_DONE_BTN).click () => @done()

    #@addColumn()

  ready: () ->
    console.log "everything is Ready"

  

  done: () ->
    $(app.Constants.OPTIONS_ERRORS).html('')
    error = false
    $(app.Constants.OPTIONS_COLUMN).each (i, element) => 
      stream = $(element).data('stream')
      if stream == undefined
        stream = @createNewStream(element)
        if !stream
          @addError("All fields are required.")
          error = true

    if !error
      @hide()
      count = $(app.Constants.OPTIONS_COLUMN).length
      _gaq.push(['_trackEvent', 'Options', 'Done', "" + count]);
      $(app.Constants.STREAM).each (i, element) ->
        $(element).removeClass("column-count1 column-count2 column-count3 column-count4 column-count5 column-count6")
        $(element).addClass("column-count#{ count }")
    else
      _gaq.push(['_trackEvent', 'Options', 'Done', 'Error']);
      

  addError: (message) ->
    $(OPTIONS_ERRORS).append("""
        <div class='alert alert-error'>
        <a class='close' data-dismiss='alert' href='#''>×</a>
        #{ message }
        </div>
      """)

  createNewStream: (element) ->
    $(element).find('.error').each((i,element)->
      $(element).removeClass('error')
    )
    error = false
    
    searchTerm = $(element).find(app.Constants.OPTIONS_SEARCH_TERM).val()
    if searchTerm == ''
      error = true
      $(element).find(app.Constants.OPTIONS_SEARCH_TERM).parent().addClass('error')
    
    refreshRate = $(element).find(app.Constants.OPTIONS_REFRESH_RATE).val()
    if refreshRate == ''
      error = true
      $(element).find(Oapp.Constants.PTIONS_REFRESH_RATE).parent().parent().addClass('error')

    if error
      return false

    _gaq.push(['_trackEvent', 'Options', 'Stream-Term', searchTerm]);
    _gaq.push(['_trackEvent', 'Options', 'Stream-Rate', refreshRate]);
    $(element).find(app.Constants.OPTIONS_SEARCH_TERM).hide()
    $(element).find(app.Constants.OPTIONS_REFRESH_RATE).parent().hide()
    $(element).find(app.Constants.OPTIONS_SEARCH_TERM_HOLDER).append("Search for <strong>#{ searchTerm }</strong> every <em>#{ refreshRate } seconds</em>")

    $(app.Constants.STREAM_HOLDER).append("""
      <div class='stream' id='stream-#{ @nextStreamId }'>
        <h3><i class='icon-search'></i> #{ searchTerm }</h3>
        <ul class='tweets'>
        </ul>
      </div>
    """)

    refreshRate = parseInt(refreshRate) * 1000

    stream = new app.gui.Stream(@analyzer, searchTerm, refreshRate, "#stream-#{ @nextStreamId }")
    $(element).data('stream', stream)
    @nextStreamId++

    return stream


