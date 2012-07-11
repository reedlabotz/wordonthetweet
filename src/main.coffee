#<< app/analyzer
#<< app/gui/options
#<< app/constants

$(document).ready ->
  init()  

init = () ->
  analyzer = new app.Analyzer()

  options = new app.gui.Options(analyzer)

  $(app.Constants.SETTINGS_BTN).tooltip({placement: 'left'})
  $(app.Constants.SETTINGS_BTN).click () -> options.show()