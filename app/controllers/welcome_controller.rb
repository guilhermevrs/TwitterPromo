gem 'twitter'

class WelcomeController < ApplicationController
	def index
	  	@arrayTweet = PromoTweet.getPromoTweetsFromServer("from:promocoes", 100)
	  	@arrayTweet.each do |t|
	  		BinarySerializer.append("t.ptw", t)
	  	end
	end
end