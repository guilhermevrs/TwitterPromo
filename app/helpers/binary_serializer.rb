module BinarySerializer extend self
	def getSizeInBytes(object)
		return Marshal.dump(object).length
	end 

	def append(filePath, object, truncate=false)
		if !truncate
			if File.exists?(filePath)
				io = File.open(filePath, "ab+")
			else
				io = File.new(filePath, "ab+")
			end
		else
			io = File.new(filePath, "wb")
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

	def insert(filePath, object, index)
		if File.exists?(filePath)
			io = File.open(filePath, "rb+")
		else
			io = File.new(filePath, "w+")
		end
		begin
			skip(io,index)
			Marshal.dump(object, io)
		rescue
			appendInFile(io,object)
		end
		io.close()
	end

	def readObject(filePath, index=0, closeIo=true, io=nil)
		begin
			if !io.nil? or File.exists?(filePath)
				if io.nil?
					io = File.open(filePath, "rb")
				end
				skip(io,index)
				loaded = Marshal.load(io)
				io.close() if closeIo
				return loaded, io
			else
				return nil, io
			end
		rescue 
				io.close() if closeIo
				return nil, io
		end
	end

	def readObjectList(filePath)
		begin
			if File.exists?(filePath)
				io = File.open(filePath, "rb")
				list = []
				while !io.eof?
					list.push(Marshal.load(io))
				end
				io.close()
				return list
			else
				return nil
			end
		rescue 
				io.close()
				return nil
		end
	end

	def skip(io, index)
		index.times() do |t|
			raise TypeError, 'Index out of range' if io.eof?
			Marshal.load(io)
		end
		raise TypeError, 'Index out of range' if io.eof?
	end
end