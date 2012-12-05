class Record

	attr_accessor :twitterID

	#methods
	def save()
		if Record.find_by_twitterID(self.twitterID).nil?
			@array.push(self)
			return true
		else
			return false
		end
	end

	#static methods
	def self.count()
		return @array.count
	end

	def self.get_all()
		return @array
	end

	def self.load_all(list)
		@array = list
	end

	def self.find_by_twitterID(id)
		if !@array.empty?
			return @array.index{|x|x.twitterID==id}
		else
			return nil
		end
	end

	def self.find_by_parameter(param,value)
		if !@array.empty?
			index = @array.index{|x|x.send(param)==value}
			return @array[index]
		else
			return nil
		end
	end

end