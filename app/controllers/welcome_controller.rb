gem 'twitter'

class WelcomeController < ApplicationController
	def index
	  	@arrayTweet = Array.new()
	  	Twitter.search("from:promocoes OR from:@boaspromocoes", :count => 10).results.map do |status|
	  	  @newPromoTweet = PromoTweet.new(:user => status.from_user, :content => status.text)
	  	  if(!status.urls.nil?)
	  	  	@newPromoTweet.url = status.urls[0].expanded_url
	  	  end
		  @arrayTweet.push @newPromoTweet
		end
	end
end