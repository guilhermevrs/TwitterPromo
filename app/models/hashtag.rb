class Hashtag < Record	

attr_accessor :text

@array = []

#methods

#static methods
	def self.factory(attributes = {})
		usrAlready = find_by_text(attributes[:text])
		if usrAlready.nil?
			o = Hashtag.new()
			attributes.each do |name, value|
				o.send("#{name}=", value)
			end
			return o
		else
			return @array[usrAlready]
		end
	end

	def self.find_by_text(text)
		if !@array.empty?
			return @array.index{|x|x.text==text}
		else
			return nil
		end
	end

end