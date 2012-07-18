class TweetView
  constructor: () ->

  element = $("""
      <li class='tweet #{ tweet['sentiment'] }'>
        <div class='title-bar'>
          <strong>@#{ tweet['username'] }</strong> 
          <em>
            <abbr class='timeago' title='#{ date.toISOString() }'>#{ date }</abbr>
          </em>
          </div>
        <img src='#{ tweet['profile_url'] }' class='avatar'>
        #{ tweet['text'] }
        <div class='clear'></div>
      </li>
    """)
  $(element).find("abbr.timeago").timeago();
    