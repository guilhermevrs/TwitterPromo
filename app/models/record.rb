class Record
	@@lastID = 0
	@@array = []

	def initialize(attributes = {})
		attributes.each do |name, value|
			send("#{name}=", value)
		end
	end

	def save()
		self.ID = @@lastID
		@@lastID += 1
		@@array.push(self)
	end

	def self.count()
		return @@lastID
	end

	def find_in_memory(idProp, idValue)
		return @@array.index{|x|x.send(idProp)==idValue}
	end

end