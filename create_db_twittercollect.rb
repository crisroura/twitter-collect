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
# title           : Create DB Twitter Collect
# name            : create_db_twittercollect.rb
# description     : This script creates the database table schema to use with twittercollect.rb script.
# author          : Cristina Roura
# date            : 2013 09 01
# version         : 0.1
# usage           : ruby create_db_twittercollect.rb
# requirements    : sqlite3
# ###########################################################################

require 'sqlite3'

db = SQLite3::Database.new( "twittercollect.db" )
db.execute( "create table twits (
	id INTEGER PRIMARY KEY, 
	text TEXT, 
	created_at TEXT,
	source TEXT,
	truncated TEXT,
	retweet_of_status_id INTEGER,
	in_reply_to_status_id INTEGER,
	in_reply_to_user_id INTEGER,
	in_reply_to_screen_name TEXT,
	in_reply_to_attrs_id TEXT,
	geo TEXT,
	retweet_count INTEGER,
	favorite_count INTEGER,
	favorited TEXT,
	retweeted TEXT,
	filter_level TEXT,
	lang TEXT,
	hashtags TEXT,
	user_mentions TEXT,
	urls TEXT,
	media TEXT,
	metadata TEXT,
	place TEXT,
	place_attributes TEXT,
	place_country TEXT,
	place_full_name TEXT,
	place_name TEXT,
	place_url TEXT,
	place_woeid INTEGER,
	place_bounding_box TEXT,
	place_country_code TEXT,
	place_parent_id TEXT,
	place_place_type TEXT,
	user_id INTEGER,
	user_name TEXT,
	user_screen_name TEXT,
	user_location TEXT,
	user_url TEXT,
	user_description TEXT,
	user_protected TEXT,
	user_followers_count INTEGER,
	user_friends_count INTEGER,
	user_listed_count INTEGER,
	user_created_at TEXT,
	user_favorites_count TEXT,
	user_utc_offset TEXT,
	user_time_zone TEXT,
	user_geo_enabled TEXT,
	user_verified TEXT,
	user_statuses_count INTEGER,
	user_lang TEXT,
	user_contributors_enabled TEXT,
	user_is_translator TEXT,
	user_profile_background_image_url TEXT,
	user_profile_image_url TEXT,
	user_profile_banner_url TEXT,
	user_default_profile TEXT,
	user_default_profile_image TEXT,
	user_following TEXT,
	user_follow_request_sent TEXT,
	user_notifications TEXT,
	insert_date INTEGER,
	operation TEXT
	);" )
