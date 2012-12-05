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
		appendInFile(io,object)
		io.close()
	end

	def appendInFile(io, object)
		#io.flock(File::LOCK_EX)
		Marshal.dump(object, io)
		#io.write(Marshal.dump(object).force_encoding("ISO-8859-1").encode("UTF-8"))
		#io.flock(File::LOCK_UN)
	end

	def readObject(filePath, index=0)
		if File.exists?(filePath)
			io = File.open(filePath, "r")
			skip(io,index)
			loaded = Marshal.load(io)
			io.close()
			return loaded
		else
			return nil
		end
	end

	def readObjectList(filePath)
		if File.exists?(filePath)
			io = File.open(filePath, "r")
			list = []
			while !io.eof?
				list.push(Marshal.load(io))
			end
			io.close()
			return list
		else
			return nil
		end
	end

	def insert(filePath, object, index)
		if File.exists?(filePath)
			io = File.open(filePath, "r+")
		else
			io = File.new(filePath, "r+")
		end
		skip(io,index)
		Marshal.dump(object, io)
		io.close()
	end

	def skip(io, index)
		index.times() do |t|
			raise TypeError, 'Index out of range' if io.eof?
			Marshal.load(io)
		end
		raise TypeError, 'Index out of range' if io.eof?
	end
end