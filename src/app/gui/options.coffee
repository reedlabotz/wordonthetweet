#<< app/gui/stream
#<< app/gui/tweet

class Options
  constructor: (analyzer) ->
    @analyzer = analyzer
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

    @addColumn()

  show: () ->
    $(app.Constants.OPTIONS_CONTAINER).modal("show")

  hide: () ->
    $(app.Constants.OPTIONS_CONTAINER).modal("hide")

  addColumn: () ->
    _gaq.push(['_trackEvent', 'Options', 'Columns', 'Add']);
    count = $(app.Constants.OPTIONS_COLUMN).length
    if count == app.Constants.MAX_COLUMNS
      @addError('There is a maximum of ' + app.Constants.MAX_COLUMNS + ' columns.')
    else
      $(app.Constants.OPTIONS_COLUMNS).append("""
        <div class="form-inline options-column">
          <div class="control-group search-term-holder">
            <input type="text" placeholder="Search term" class="input-medium search-term"> 
          </div>
          <div class="control-group">
              <div class="input-append">
                <input type="text" placeholder="Refresh rate" class="input-small refresh-rate"><span class="add-on">seconds</span>
              </div>
          </div>
          <i class="remove-column icon-remove"></i>
        </div>
      """)
      $(app.Constants.OPTIONS_REMOVE_COLUMN).click (e) => 
        @removeColumn(e.target)

  removeColumn: (element) ->
    _gaq.push(['_trackEvent', 'Options', 'Columns', 'Remove']);
    stream = $(element).parent().data('stream')
    if stream != undefined
      stream.destroy()
    $(element).parent().remove()

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


