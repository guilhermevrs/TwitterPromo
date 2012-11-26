module BinarySerializer extend self
	def getSizeInBytes(object)
		return Marshal.dump(object).length
	end 

	def append(filePath, object)
		if File.exists?(filePath)
			io = File.open(filePath, "a+")
		else
			io = File.new(filePath, "a+")
		end
		Marshal.dump(object, io)
		#io.write(Marshal.dump(object).force_encoding("ISO-8859-1").encode("UTF-8"))
	end

	def insert(object, index)
	end
end