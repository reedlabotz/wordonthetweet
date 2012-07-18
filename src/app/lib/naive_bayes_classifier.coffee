#<< app/lib/classifier

# adapted from https://github.com/sonesuke/classifier
class NaiveBayesClassifier extends app.lib.Classifier
  constructor: () ->
    super

  classify: (text) ->
    tokens = text.tokenize()
    probs = []
    max = 0.0
    best = null
    for category of @data.categoryCount
      probs[category] = @getProbability(tokens,category)
      if probs[category] > max
        max = probs[category]
        best = category

    return [best, probs[category]]

  getProbability: (features, category) ->
    categoryProbability = @getCategoryCount(category) / @getTotalCount()
    getProbability = (feature, category) =>
      @getFeatureProbability(feature, category)
    probability = 1
    probability *= @getWeightedProbability(feature, category, getProbability) for feature in features
    probability * categoryProbability

  getFeatureProbability: (feature, category) ->
    categoryCount = @getCategoryCount(category)
    return 0.0 if categoryCount == 0
    featureCount = @getFeatureCount(feature, category)
    1.0 * featureCount / categoryCount

  getCategoryCount: (category) ->
    return 0.0 if not @data.categoryCount[category]?
    @data.categoryCount[category]

  getFeatureCount: (feature, category) ->
    return 0.0 if not @data.featureCount[category]?
    return 0.0 if not @data.featureCount[category][feature]?
    1 * @data.featureCount[category][feature]

  getCategoryCount: (category) ->
    return 0.0 if not @data.categoryCount[category]?
    @data.categoryCount[category]

  getTotalCount: ->
    sum = 0
    sum += value for key, value of @data.categoryCount
    sum

  getWeightedProbability: (feature, category, getProbabilityFunc) ->
    weight = 1.0
    ap = 0.5
    basicProbability = getProbabilityFunc(feature, category)
    sum = 0
    sum += @getFeatureCount(feature, category) for category in @getCategories()
    ((weight * ap) + (sum * basicProbability)) / (weight + sum)

  getCategories: ->
    key for key, value of @categoryCount
