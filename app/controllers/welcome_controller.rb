gem 'twitter'
require 'btree'

class WelcomeController < ApplicationController
	def index
	  	@users = BinarySerializer.readObjectList("users.dat")
	  	@tweets = BinarySerializer.readObjectList("tweets.dat")
	  	User.load_all(@users)
	  	Tweet.load_all(@tweets)
	  	@tree = Btree.create(5) # degree = 5
	  	100.times() do |i|
	  		begin
	  			@tree.insert(20+Random.rand(100),"ba" * i)
	  		rescue
	  		end
	  	end
	end

	#def load
	#	PromoTweet.getPromoTweetsFromServer(100)
	#end

end