class Record

	#static
	@@lastID = 0
	@@array = []

	attr_accessor :twitterID, :ID

	#methods
	def save()
		if Record.find_by_twitterID(self.twitterID).nil?
			self.ID = @@lastID
			@@lastID += 1
			@@array.push(self)
			return true
		else
			return false
		end
	end

	#static methods
	def self.count()
		return @@lastID
	end

	def self.get_all()
		return @@array
	end

	def self.load_all(list)
		@@array = list
	end

	def self.find_by_twitterID(id)
		if !@@array.empty?
			return @@array.index{|x|x.twitterID==id}
		else
			return nil
		end
	end
end