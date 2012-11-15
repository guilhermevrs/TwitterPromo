gem 'twitter'

class WelcomeController < ApplicationController
	def index
	  	@arrayTweet = PromoTweet.getPromoTweetsFromServer("from:promocoes", 100)
	end
end