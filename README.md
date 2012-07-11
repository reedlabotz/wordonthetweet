Word on the Tweet
=================
Word on the tweet is a twitter dashboard that allows you to see what the world is thinking about an issue.
Tweets are pulled in from twitter and analyzed for positive or negative sentiments.

Live Demo: http://reedlabotz.github.com/wordonthetweet

Dependencies
------------
To publish the code doesn't require anything special. Just copy files from gh-pages branch to your server. 
To use the rake commands, you will need the following.
```bash
npm install -g coffee-script coffee-toaster
```

Develope
--------
To watch the coffee script and compile
```bash
rake watch
```

A simple python server running on `http://localhost:8000`
```bash
rake server
```

Clean up files
```bash
rake clean
```

Publish
-------
To copy relevant files from current branch to gh-pages
```bash
rake publish && git push origin gh-pages
```

Links
-----
* AFINN bag of words - http://fnielsen.posterous.com/simplest-sentiment-analysis-in-python-with-af

* Sanders Twitter Sentiment Corpus - http://www.sananalytics.com/lab/twitter-sentiment/

* Twitter sentiment - https://sites.google.com/site/twittersentimenthelp/home

* Naive bayes classifier - https://github.com/sonesuke/classifier

* Async javascript library - https://github.com/caolan/async

* Timeago javascritp library - http://timeago.yarp.com/

* Enhanced jQuery animations - http://github.com/benbarnett/jQuery-Animate-Enhanced

* Twitter bootstrap - http://twitter.github.com/bootstrap/

* Icon Fonts - http://fortawesome.github.com/Font-Awesome

* jQuery - http://jquery.com/
