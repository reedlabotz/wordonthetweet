class OptionsView
  constructor: () ->

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