$(document).ready ->
  analyzer = new Analyzer('AFINN-111-emo.txt')
  stream = new Stream(analyzer, 'hulu', 10 * 1000)