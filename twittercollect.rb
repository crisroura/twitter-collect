# Twitter Collect

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# 
                                                        
# ###########################################################################
# title           : Twitter Collect
# name            : twittercollect.rb
# description     : This script collects from twitter public stream 
#                   in real time filtering by keywords and user ids
# author          : Cristina Roura
# date            : 2014 11 18
# version         : 0.2
# usage           : ruby twittercollect.rb
# requirements    : tweetstream
# ###########################################################################

require 'tweetstream'
require 'sqlite3'
require 'logger'

# Set your Twitter API Keys
TweetStream.configure do |config|
        config.consumer_key       = 'xxxxxxxxxxxxxxxxxxxxxxxxxx'
        config.consumer_secret    = 'xxxxxxxxxxxxxxxxxxxxxxxxxx'
        config.oauth_token        = 'xxxxxxxxxxxxxxxxxxxxxxxxxx'
        config.oauth_token_secret = 'xxxxxxxxxxxxxxxxxxxxxxxxxx'
        config.auth_method        = :oauth
      end

@client = TweetStream::Client.new
@db = SQLite3::Database.open "twittercollect.db"

@log = Logger.new('twittercollect.log')
@log.level = Logger::DEBUG
@log.info "START LOGIN"
 
    puts 'Starting collector'

    @client.on_delete do |status_id, user_id|
        puts "DELETE message - #{status_id} #{user_id}"
        @log.error "DELETE message - #{status_id} #{user_id}"
        #Tweet.delete(status_id)
      end

    @client.on_limit do |skip_count|
        puts "Error - Limit"
        @log.error "Error - Limit"
        # do something
        sleep 1
      end

    @client.on_enhance_your_calm do
        puts "Error - Enhance your calm"  
        @log.error "Error - Enhance your calm"
        # do something
        sleep 1
    end

    @client.on_error do |message|
        puts "Error - error: #{message}"
        @log.error "Error - error: #{message}"
        # do something
    end

    @client.on_reconnect do |timeout, retries|
        puts "Error - error: #{timeout} #{retries}"
        @log.error "Error - error: #{timeout} #{retries}"
        # do something
    end

    #Set the keywords to filter
    keywords='example','foursquare.com'
    @log.info keywords
    query_track = TweetStream::Arguments.new(keywords)

    print query_track

    #Set the user ids to filter
    user_ids = 783214, 6253282
    @log.info user_ids
    query_follow = TweetStream::Arguments.new(user_ids)

    print query_follow

    # Query track & follow
    query_params = {:track => query_track, :follow => query_follow}

    # Query only track
    #query_params = {:track => query_track}


@client.filter(query_params) do |status|
      if status.entities? && status.hashtags?
        hashtags = Array.new
        status.hashtags.each do |hashtag|
          hashtags << hashtag.text
        end
      else
        hashtags = "\"\""
      end

      if status.entities? && status.urls?
        urls = Array.new
        status.urls.each do |url|
          urls <<  ["#{url.uri}","#{url.expanded_uri}","#{url.display_url}"]
        end
      else
        urls = "[]"
      end    
  
      if status.entities? && status.user_mentions?
        user_mentions = Array.new
        status.user_mentions.each do |user_mentioned|
          user_mentions << [user_mentioned.id, user_mentioned.name, user_mentioned.screen_name]
        end
      else
        user_mentions = "[]"
      end

      if status.entities? && status.media?
        media_urls = Array.new
        status.media.each do |media_url|
          media_urls << ["#{media_url.display_url}", "#{media_url.expanded_url}", "#{media_url.media_url}", "#{media_url.url}"]
        end
      else
        media_urls = "[]"
      end

      if status.geo.nil?
        geo = ''
      else
        geo = status.geo.coordinates.to_s
      end

      if status.retweet?
        retweet_of_status_id =  status.retweeted_status.id
      else
        retweet_of_status_id = 0
      end

      in_reply_to_attrs_id = '' #Deprecated?

      #Prepare and store in log format
      tweet = "text=\"#{status.text}\" created_at=\"#{status.created_at}\" id=\"#{status.id}\" source=\"#{status.source}\" truncated=\"#{status.truncated?}\" retweet_of_status_id=\"#{retweet_of_status_id}\" in_reply_to_status_id=\"#{status.in_reply_to_status_id}\" in_reply_to_user_id=\"#{status.in_reply_to_user_id}\" in_reply_to_screen_name=\"#{status.in_reply_to_screen_name}\" in_reply_to_attrs_id=\"#{in_reply_to_attrs_id}\" "
      if status.geo.nil?
        tweet = tweet + "geo=[] "
      else
        tweet = tweet + "geo=#{status.geo.coordinates} "
      end
      tweet = tweet + "retweet_count=\"#{status.retweet_count}\" favorite_count=\"#{status.favorite_count}\" favorited=\"#{status.favorited?}\" retweeted=\"#{status.retweeted?}\" filter_level=\"#{status.filter_level}\" lang=\"#{status.lang}\" "
      tweet = tweet + "hashtags=#{hashtags} user_mentions=#{user_mentions} urls=#{urls} media=#{media_urls} metadata=\"#{status.metadata}\" "
      if status.place.nil?
        tweet = tweet + "place=\"false\" "
      else
        tweet = tweet + "place=\"true\" place_attributes=#{status.place.attributes} place_country=#{status.place.country} place_full_name=#{status.place.full_name} place_name=#{status.place.name} place_url=#{status.place.url} place_woeid=#{status.place.woeid} place_bounding_box=#{status.place.bounding_box.coordinates} place_country_code=#{status.place.country_code} place_parent_id=#{status.place.parent_id} place_place_type=#{status.place.place_type} "
      end
      tweet = tweet + "user_id=\"#{status.user.id}\" user_name=\"#{status.user.name}\" user_screen_name=\"#{status.user.screen_name}\" user_location=\"#{status.user.location}\" user_url=\"#{status.user.url}\" user_description=\"#{status.user.description}\" user_protected=\"#{status.user.protected?}\" user_followers_count=\"#{status.user.followers_count}\" user_friends_count=\"#{status.user.friends_count}\" user_listed_count=\"#{status.user.listed_count}\" user_created_at=\"#{status.user.created_at}\" user_favorites_count=\"#{status.user.favorites_count}\" user_utc_offset=\"#{status.user.utc_offset}\" user_time_zone=\"#{status.user.time_zone}\" user_geo_enabled=\"#{status.user.geo_enabled?}\" user_verified=\"#{status.user.verified?}\" user_statuses_count=\"#{status.user.statuses_count}\" user_lang=\"#{status.user.lang}\" user_contributors_enabled=\"#{status.user.contributors_enabled?}\" user_translator=\"#{status.user.translator?}\" user_profile_background_image_url=\"#{status.user.profile_background_image_url}\" user_profile_image_url=\"#{status.user.profile_image_url}\" user_profile_banner_url=\"#{status.user.profile_banner_url}\" user_default_profile=\"#{status.user.default_profile?}\" user_default_profile_image=\"#{status.user.default_profile_image?}\" user_following=\"#{status.user.following?}\" user_follow_request_sent=\"#{status.user.follow_request_sent?}\" user_notifications=\"#{status.user.notifications?}\""
      @log.info tweet

      puts "Saving tweet: #{status.id} - #{status.text}"

      #Store into DB
      insert_date = Time.now.to_i

      begin
        @db.prepare ("INSERT INTO twits VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)") do |stmt|
          if status.place.nil?
            stmt.execute status.id.to_i, status.text.to_s, status.created_at.to_s, status.source.to_s,status.truncated?.to_s,retweet_of_status_id,status.in_reply_to_status_id.to_i,status.in_reply_to_user_id.to_i,status.in_reply_to_screen_name.to_s,in_reply_to_attrs_id.to_s,geo,status.retweet_count.to_i,status.favorite_count.to_i,status.favorited?.to_s,status.retweeted?.to_s,status.filter_level.to_s,status.lang.to_s,hashtags.to_s,user_mentions.to_s,urls.to_s,media_urls.to_s,status.metadata.to_s,'false','','','','','',0,'','',0,'',status.user.id.to_i,status.user.name.to_s,status.user.screen_name.to_s,status.user.location.to_s,status.user.url.to_s,status.user.description.to_s,status.user.protected?.to_s,status.user.followers_count.to_i,status.user.friends_count.to_i,status.user.listed_count.to_i,status.user.created_at.to_s,status.user.favorites_count.to_s,status.user.utc_offset.to_s,status.user.time_zone.to_s,status.user.geo_enabled?.to_s,status.user.verified?.to_s,status.user.statuses_count.to_i,status.user.lang.to_s,status.user.contributors_enabled?.to_s,status.user.translator?.to_s,status.user.profile_background_image_url.to_s,status.user.profile_image_url.to_s,status.user.profile_banner_url.to_s,status.user.default_profile?.to_s,status.user.default_profile_image?.to_s,status.user.following?.to_s,status.user.follow_request_sent?.to_s,status.user.notifications?.to_s,insert_date,'TEST'
          else
            stmt.execute status.id, status.text, status.created_at.to_s, status.source,status.truncated?.to_s,retweet_of_status_id,status.in_reply_to_status_id.to_i,status.in_reply_to_user_id.to_i,status.in_reply_to_screen_name.to_s,in_reply_to_attrs_id.to_s,geo,status.retweet_count.to_i,status.favorite_count.to_i,status.favorited?.to_s,status.retweeted?.to_s,status.filter_level.to_s,status.lang.to_s,hashtags.to_s,user_mentions.to_s,urls.to_s,media_urls.to_s,status.metadata.to_s,'true',status.place.attributes.to_s,status.place.country.to_s,status.place.full_name.to_s,status.place.name.to_s,status.place.url.to_s,status.place.woeid.to_i,status.place.bounding_box.coordinates.to_s,status.place.country_code.to_s,status.place.parent_id.to_s,status.place.place_type.to_s,status.user.id.to_i,status.user.name.to_s,status.user.screen_name.to_s,status.user.location.to_s,status.user.url.to_s,status.user.description.to_s,status.user.protected?.to_s,status.user.followers_count.to_i,status.user.friends_count.to_i,status.user.listed_count.to_i,status.user.created_at.to_s,status.user.favorites_count.to_s,status.user.utc_offset.to_s,status.user.time_zone.to_s,status.user.geo_enabled?.to_s,status.user.verified?.to_s,status.user.statuses_count.to_i,status.user.lang.to_s,status.user.contributors_enabled?.to_s,status.user.translator?.to_s,status.user.profile_background_image_url.to_s,status.user.profile_image_url.to_s,status.user.profile_banner_url.to_s,status.user.default_profile?.to_s,status.user.default_profile_image?.to_s,status.user.following?.to_s,status.user.follow_request_sent?.to_s,status.user.notifications?.to_s,insert_date,'TEST'
          end
        end
      rescue SQLite3::Exception => e
        puts "Error - #{e}"
      end
end
