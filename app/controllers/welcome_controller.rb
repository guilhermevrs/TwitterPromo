gem 'twitter'

class WelcomeController < ApplicationController
  def index
  	@arrayTweet = Array.new()
  	Twitter.search("to:justinbieber love", :count => 100000).results.map do |status|
	  @arrayTweet.push "#{status.from_user}: #{status.text}"
	end
	Twitter.search("to:justinbieber love", :count => 100000).results.map do |status|
	  @arrayTweet.push "#{status.from_user}: #{status.text}"
	end
	Twitter.search("to:justinbieber love", :count => 100000).results.map do |status|
	  @arrayTweet.push "#{status.from_user}: #{status.text}"
	end
	Twitter.search("to:justinbieber love", :count => 100000).results.map do |status|
	  @arrayTweet.push "#{status.from_user}: #{status.text}"
	end
  end
end
