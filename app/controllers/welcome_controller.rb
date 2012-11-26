gem 'twitter'

class WelcomeController < ApplicationController
	def index
	  	@arrayTweet = PromoTweet.getPromoTweetsFromServer("from:promocoes", 100)
	  	BinarySerializer.append("t.tpdb", @arrayTweet[0])
	  	#@arrayTweet.each do |t|
	  	#	BinarySerializer.append("t.tpdb", t)
	  	#end
	end
end