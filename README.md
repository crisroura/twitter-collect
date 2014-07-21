twitter-collect
===============

This script collects information from twitter public stream in real time filtering by previously configured keywords and user ids.
It uses tweetstream library and stores the information in a log file and a SQLite database.

Check default access level restrictions and rate limitations in https://dev.twitter.com/docs/api/1.1/post/statuses/filter


Configuration
----------------
* Create twittercollect.db database using create_db_twittercollect.rb script
```shell
$ ruby twittercollect.rb
```
* Configure OAuth authentication with your Twitter API Keys
```
TweetStream.configure do |config|
        config.consumer_key       = 'xxxxxxxxxxxxxxxxxxxxxxxxxx'
        config.consumer_secret    = 'xxxxxxxxxxxxxxxxxxxxxxxxxx'
        config.oauth_token        = 'xxxxxxxxxxxxxxxxxxxxxxxxxx'
        config.oauth_token_secret = 'xxxxxxxxxxxxxxxxxxxxxxxxxx'
        config.auth_method        = :oauth
      end
```
* Set "keywords" and "user_ids" to collect
```
keywords='twitter','twitter streaming','foursquare.com'
...
user_ids = 783214, 6253282
```

Usage example
----------------
```shell
$ screen
$ ruby twittercollect.rb
```
