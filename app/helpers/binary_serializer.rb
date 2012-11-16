module BinarySerializer extend self
	def append(filePath, object)
		if File.exists?(filePath)
			io = File.open(filePath, "a+")
		else
			io = File.new(filePath, "a+")
		end
		
		io.write(Marshal.dump(object).force_encoding("ISO-8859-1").encode("UTF-8"))
	end
end