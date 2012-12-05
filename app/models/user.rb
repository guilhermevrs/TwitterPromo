class User < Record	

attr_accessor :name

@array = []

#methods

#static methods
	def self.factory(attributes = {})
		usrAlready = find_by_twitterID(attributes[:TwitterID])
		if usrAlready.nil?
			o = User.new()
			attributes.each do |name, value|
				o.send("#{name}=", value)
			end
			return o
		else
			return @array[usrAlready]
		end
	end
end