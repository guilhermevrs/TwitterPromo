class PromoTweet

	def initialize(attributes = {})
		attributes.each do |name, value|
			send("#{name}=", value)
		end
	end

	def self.getPromoTweetsFromServer(count)
		@arrayTweet = Array.new()
	  	return Twitter.search("from:promocoes", :count => count).results
		#  	  @newPromoTweet = PromoTweet.new(:user => status.from_user, :content => status.text, :tweetID => status.id, :userID => status.user.id)

		#  	  if(!status.urls.nil? && status.urls.length > 0)
		 # 	  	@newPromoTweet.url = status.urls[status.urls.length-1].expanded_url
		  #	  	
		  #	  	status.urls.each do |ur|
		  #	  		@newPromoTweet.content = @newPromoTweet.content.gsub(ur.url, "")
		  #	  	end

		  #	  end
			#  @arrayTweet.push @newPromoTweet
		#end
		#return @arrayTweet
	end

	def save(filePath)
		if File.exists?(filePath)
			io = File.open(filePath, "a+")
		else
			io = File.new(filePath, "a+")
		end
		io.write(Marshal.dump(self))
	end
end