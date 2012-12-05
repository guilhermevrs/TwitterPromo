gem 'twitter'

class WelcomeController < ApplicationController
	def index
	  	#arrayTweet = PromoTweet.getPromoTweetsFromServer("from:promocoes OR from:achei_promocao", 10)
	  	#arrayTweet.each do |t|
	  	#	usr = User.factory(:twitterID => t.userID, :name=>t.user)
	  	#	if usr.save()
	  	#		BinarySerializer.append("users.tdb", usr)
	  	#	end
	  	#	twt = Tweet.factory(:twitterID => t.tweetID, :content=>t.content, :userID=>usr.ID)
	  	#	if twt.save()
	  	#		BinarySerializer.append("tweets.tdb", twt)
	  	#	end
	  	#end
		usr = User.factory(:twitterID => 2, :name=>"t.user")
  		if usr.save()
  			BinarySerializer.append("users.tdb", usr)
  		end

  		usr = User.factory(:twitterID => 3, :name=>"t.CH")
  		if usr.save()
  			BinarySerializer.append("users.tdb", usr)
  		end

  		usr = User.factory(:twitterID => 98, :name=>"Insert")
  		if usr.save()
  			BinarySerializer.insert("users.tdb", usr, 0)
  		end



	  	@users = BinarySerializer.readObjectList("users.tdb")
	  	@tweets = BinarySerializer.readObjectList("tweets.tdb")
	  	#@arrayTweet[0].number = Tweet.count()
	  	#@arrayTweet[1].number = User.count()
	end

end