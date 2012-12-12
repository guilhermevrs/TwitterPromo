class Tweet < Record	

attr_accessor :userID, :content, :username, :geo

def hashtags
	if @hashtags.nil?
		@hashtags = []
	end
	@hashtags
end

def hashtags=(value)
	@hashtags = value
end

@array = []

#methods

#static methods
	def self.factory(attributes = {})
		usrAlready = find_by_twitterID(attributes[:twitterID])
		if usrAlready.nil?
			o = Tweet.new()
			attributes.each do |name, value|
				o.send("#{name}=", value)
			end
			return o
		else
			return @array[usrAlready]
		end
	end
end