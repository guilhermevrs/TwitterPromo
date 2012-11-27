class User < Record
	attr_accessor :ID, :name

	def save()
		if !self.find_in_memory(:name,self.name).nil?
			super
			return true
		end
		return false
	end
end