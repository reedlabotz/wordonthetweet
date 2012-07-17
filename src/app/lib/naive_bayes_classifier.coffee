#<< app/lib/classifier

class NaiveBayesClassifier extends app.lib.Classifier
  constructor: (@categories) ->
    super

  classify: (text) ->
    tokens = text.tokenize()
    probs = []
    max = 0.0
    best = null
    for category in @categories
      probs[category] = @getProbability(tokens,category)
      if probs[category] > max
        max = probs[category]
        best = category

    return best


 ##### to be deleted ##### 


# adapted from https://github.com/sonesuke/classifier
class Backend
    constructor: (dictionary_path = null) ->
        @featureCount = {}
        @categoryCount = {}
        if dictionary_path != null
            @loadData(dictionary_path)

    outputData: (callback) ->
        featureCount = @featureCount
        categoryCount = @categoryCount
        callback {'featureCount': featureCount, 'categoryCount': categoryCount}

    loadData: (path) ->
        $.getJSON path, (data) => 
            @featureCount = data['featureCount']
            @categoryCount = data['categoryCount']
    
    incrementFeature: (feature, category) ->
        @featureCount[category] = {} if not @featureCount[category]?
        @featureCount[category][feature] = 0 if not @featureCount[category][feature]?
        @featureCount[category][feature] += 1

    incrementCategory: (category) ->
        @categoryCount[category] = 0 if not @categoryCount[category]?
        @categoryCount[category] += 1

    getFeatureCount: (feature, category) ->
        return 0.0 if not @featureCount[category]?
        return 0.0 if not @featureCount[category][feature]?
        1 * @featureCount[category][feature]

    getCategoryCount: (category) ->
        return 0.0 if not @categoryCount[category]?
        @categoryCount[category]

    getTotalCount: ->
        sum = 0
        sum += value for key, value of @categoryCount
        sum

    getCategories: ->
        key for key, value of @categoryCount


class Classifier
    constructor: (dictionary_path = null) ->
        @backend = new app.classifiers.Backend(dictionary_path)


    loadData: (dictionary_path) ->
        @backend.loadData dictionary_path

    train: (tweet) ->
        features = tweet.tokenize()
        @backend.incrementFeature(feature, tweet['sentiment']) for feature in features
        @backend.incrementCategory(tweet['sentiment'])

    getFeatureProbability: (feature, category) ->
        categoryCount = @backend.getCategoryCount(category)
        return 0.0 if categoryCount == 0
        featureCount = @backend.getFeatureCount(feature, category)
        1.0 * featureCount / categoryCount
    
    getWeightedProbability: (feature, category, getProbabilityFunc) ->
        weight = 1.0
        ap = 0.5
        basicProbability = getProbabilityFunc(feature, category)
        sum = 0
        sum += @backend.getFeatureCount(feature, category) for category in @backend.getCategories()
        ((weight * ap) + (sum * basicProbability)) / (weight + sum)

    outputData: (callback) ->
        @backend.outputData callback


class NaiveBayesClassifier extends app.classifiers.Classifier
    constructor: (dictionary_path = null) ->
        super dictionary_path
        @thresholds = []

    loadData: (dictionary_path) ->
        super dictionary_path

    getProbability: (item, category) ->
        categoryProbability = @backend.getCategoryCount(category) / @backend.getTotalCount()
        features = item.tokenize()
        self = this
        getProbability = (feature, category) ->
            self.getFeatureProbability(feature, category)
        probability = 1
        probability *= @getWeightedProbability(feature, category, getProbability) for feature in features
        probability * categoryProbability

    setThreshold: (category, t) ->
        @thresholds[category] = t

    getThreshold: (category) ->
        @thresholds[category] || 0

    classify: (tweet) ->
        probs = []
        max = 0.0
        best = null
        for category in @backend.getCategories()
            probs[category] = @getProbability(tweet,category)
            if probs[category] > max
                max = probs[category]
                best = category

        for category, value of probs
            continue if category == best
            return 'unknown' if probs[category] * @getThreshold(best) > probs[best]
        return best
