gem 'twitter'
require 'btree'

class WelcomeController < ApplicationController
	def index
	  	flash[:error] = PromoTweet.initializeTrees()
	  	load = params[:load]
	  	if !(load.nil?) and load=="true"
	  		case params[:search_method]
	  		when 'c'
	  			@tServerF = PromoTweet.getPromoTweetsFromServer("\"#{params[:q]}\"",300)
	  		when 'a'
	  			@tServerF = PromoTweet.getPromoTweetsFromServer("from:#{params[:q]}",300)
	  		when 'h'
	  			@tServerF = PromoTweet.getPromoTweetsFromServer("\##{params[:q]}",300)
	  		else
	  			@tServerF = PromoTweet.getPromoTweetsFromServer(300)
	  		end
	  		PromoTweet.updateIDtweet(@tServerF)
	  		flash[:notice] = "Operacao realizada"
	  	else
	  		PromoTweet.updateLocalIndices()
	  		case params[:search_method]
	  		when 'c'
	  			@tweets = BinarySerializer.readObjectList("tweets.dat")
	  			@tweets = PromoTweet.getTweetsByContent(@tweets, params[:q])
	  		when 'a'
	  			@tweets = PromoTweet.getTweetsByAuthor(params[:q])
	  		when 'h'
	  			@tweets = PromoTweet.getTweetsByHashtags(params[:q])
	  		else
	  			@tweets = BinarySerializer.readObjectList("tweets.dat")
	  		end
	  	end
	  	if !params[:sort].nil? and params[:sort]
	  		@tweets.reverse!
	  	end
	  	@tTree = PromoTweet.getTweetTree()
	  	@uTree = PromoTweet.getUserTree()
	  	@hTree = PromoTweet.getHashtagTree()
	  	@utTree = PromoTweet.getUserTweetTree()
	end

	def autores
		listUsers = BinarySerializer.readObjectList("users.dat")
		@classAutores = []
		if !listUsers.nil?
			listUsers.each do |u|
				novoItem = []
				novoItem.push(u.name)
				novoItem.concat PromoTweet.getTweetsByAuthor(u.name.downcase)
				@classAutores.push(novoItem)
			end
		end
	end

	def hashtags
		listUsers = BinarySerializer.readObjectList("hashtags.dat")
		# @classAutores = []
		# if !listUsers.nil?
		# 	listUsers.each do |u|
		# 		novoItem = []
		# 		novoItem.push("\##{u.text}")
		# 		novoItem.concat PromoTweet.getTweetsByHashtags(u.text)
		# 		@classAutores.push(novoItem)
		# 	end
		# end
		 @classAutores = false
		 @test = listUsers
	end

end