class AppController
  constructor: () ->
    @bag_of_words_classifier = new app.lib.BagOfWordsClassifier()
    @bag_of_words_classifier.loadData("data/afinn-111-emo.json")
    
    @emoticon_naive_bayes_classifier = new app.lib.NaiveBayesClassifier()
    @emoticon_naive_bayes_classifier.loadData("data/emoticon.json")

    @labeled_naive_bayes_classifier = new app.lib.NaiveBayesClassifier()
    @labeled_naive_bayes_classifier.loadData("data/labeled.json")