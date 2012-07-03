$(document).ready ->
  $("#options").modal({
    backdrop: true,
  })
  $("#options").modal("show")
  $("#settings-btn").tooltip({placement: 'left'})
  analyzer = new Analyzer('AFINN-111-emo.txt')
  stream = new Stream(analyzer, 'hulu', 10 * 1000, '#results')
  stream2 = new Stream(analyzer, 'hulu plus', 10 * 1000, '#results2')
  stream3 = new Stream(analyzer, '@hulu', 10 * 1000, '#results3')

  $("#settings-btn").click () -> $("#options").modal("show")