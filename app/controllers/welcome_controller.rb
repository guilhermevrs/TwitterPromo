gem 'twitter'

class WelcomeController < ApplicationController
	def index
	  	@arrayTweet = PromoTweet.getPromoTweetsFromServer("from:promocoes", 100)
	  	@arrayTweet.each do |t|
	  		usr = User.new(:name=>t.user)
	  		usr.save()
	  		twt = Tweet.new(:content=>t.content, :userID=>usr.ID)
	  		twt.save()
	  		BinarySerializer.append("tweets.tdb", twt)
	  		BinarySerializer.append("users.tdb", usr)
	  	end

	  	@arrayTweet[0].number = Tweet.count()
	  	@arrayTweet[1].number = User.count()
	end

end