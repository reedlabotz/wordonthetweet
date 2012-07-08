$(document).ready ->
  init()  

init = () ->
  analyzer = new Analyzer()

  options = new Options(analyzer)

  $(SETTINGS_BTN).tooltip({placement: 'left'})
  $(SETTINGS_BTN).click () -> options.show()