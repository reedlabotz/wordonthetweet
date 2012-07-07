# adapted from https://github.com/sonesuke/classifier

class Backend
    constructor: ->
        @featureCount = []
        @categoryCount = []
    
    incrementFeature: (feature, category) ->
        @featureCount[feature] = [] if not @featureCount[feature]?
        @featureCount[feature][category] = 0 if not @featureCount[feature][category]?
        @featureCount[feature][category] += 1

    incrementCategory: (category) ->
        @categoryCount[category] = 0 if not @categoryCount[category]?
        @categoryCount[category] += 1

    getFeatureCount: (feature, category) ->
        return 0.0 if not @featureCount[feature]?
        return 0.0 if not @featureCount[feature][category]?
        1 * @featureCount[feature][category]

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
    constructor: (getFeatureFunc) ->
        @getFeatureFunc = getFeatureFunc
        @backend = new Backend()

    training: (item, category) ->
        features = @getFeatureFunc(item)
        @backend.incrementFeature(feature, category) for feature in features
        @backend.incrementCategory(category)

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


class NaiveBayesClassifier extends Classifier
    constructor: (getFeatureFunc) ->
        super getFeatureFunc
        @thresholds = []

    getProbability: (item, category) ->
        categoryProbability = @backend.getCategoryCount(category) / @backend.getTotalCount()
        features = @getFeatureFunc(item)
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

    classify: (item) ->
        probs = []
        max = 0.0
        best = 'hi'
        for category in @backend.getCategories()
            probs[category] = @getProbability(item,category)
            if probs[category] > max
                max = probs[category]
                best = category

        for category, value of probs
            continue if category == best
            return 'unknown' if probs[category] * @getThreshold(best) > probs[best]
        best
