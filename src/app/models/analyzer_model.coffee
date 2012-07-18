class AnalyzerModel
  constructor: () ->
    @ready = false
    @bag_of_words_classifier = new app.lib.BagOfWordsClassifier()
    @bag_of_words_classifier.loadData("data/afinn-111-emo.json")
    $(@bag_of_words_classifier).on app.lib.Classifier.Events.Ready, (event, object) => @checkReady(object)

    @emoticon_naive_bayes_classifier = new app.lib.NaiveBayesClassifier()
    @emoticon_naive_bayes_classifier.loadData("data/emoticon.json")
    $(@emoticon_naive_bayes_classifier).on app.lib.Classifier.Events.Ready, (event, object) => @checkReady(object)

    @labeled_naive_bayes_classifier = new app.lib.NaiveBayesClassifier()
    @labeled_naive_bayes_classifier.loadData("data/labeled.json")
    $(@labeled_naive_bayes_classifier).on app.lib.Classifier.Events.Ready, (event, object) => @checkReady(object)

  checkReady: (object) ->
    if @bag_of_words_classifier.ready && @emoticon_naive_bayes_classifier.ready && @labeled_naive_bayes_classifier.ready
      $(@).trigger app.models.AnalyzerModel.Events.Ready, @

  @Events = {
    Ready: "AnalyzerModel.Events.Ready"
  }