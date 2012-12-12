require 'btree'
class PromoTweet

	@@userTree = nil
	@@tweetTree = nil
	@@hashtagTree = nil
	@@userTweetTree = nil
	@@tweetWriteLock = Mutex.new

	def self.getUserTree()
		return @@userTree
	end

	def self.getHashtagTree()
		return @@hashtagTree
	end

	def self.getTweetTree()
		return @@tweetTree
	end

	def self.getUserTweetTree()
		return @@userTweetTree
	end

	def self.getTweetsByContent(array, text)
		return array.find_all{|item| item.content.downcase().scan(text.downcase).count > 0}
	end

	def self.getTweetsByAuthor(username)
		username = username.downcase
		returnArray = []
		array = @@userTweetTree[username]
		return getTweetByRandomAccess(array)
	end

	def self.getTweetsByHashtags(hashtag)
		returnArray = []
		hashtag = hashtag.downcase
		array = @@hashtagTree[hashtag]
		return getTweetByRandomAccess(array)
	end

	def self.getTweetByRandomAccess(array)
		returnArray = []
		if !array.nil? and !array.empty?
			lastIndex = 0
			isFirst = true
			io = nil
			array.each do |index|
				if isFirst
					isFirst = false
					indexAtual = index
				else
					indexAtual = (index - lastIndex).abs
				end
				lastIndex = index + 1
				binaryArray = BinarySerializer.readObject("tweets.dat", indexAtual, false, io)
				returnArray.push(binaryArray[0])
				io = binaryArray[1]
			end
			io.close()
			return returnArray
		else
			return nil
		end
	end

	def self.updateLocalIndices()
		@@userTree = nil
		@@tweetTree = nil
		@@hashtagTree = nil
		@@userTweetTree = nil
		initializeTrees()
	end

	def self.initializeTrees()
		begin
			uTree = BinarySerializer.readObject("user_id.index")[0]
			if uTree.nil?
				@@userTree = Btree.create(10) if @@userTree.nil?
			else
				@@userTree = uTree
			end
		rescue
			return "Arquivo de indice de usuarios corrompido"
		end

		begin
			uTree = BinarySerializer.readObject("tweet_id.index")[0]
			if uTree.nil?
				@@tweetTree = Btree.create(10) if @@tweetTree.nil?
			else
				@@tweetTree = uTree
			end
		rescue
			return "Arquivo de indice de tweets corrompido"
		end

		begin
			uTree = BinarySerializer.readObject("hashtag_id.index")[0]
			if uTree.nil?
				@@hashtagTree = Btree.create(10) if @@hashtagTree.nil?
			else
				@@hashtagTree = uTree
			end
		rescue
			return "Arquivo de indice de hashtag corrompido"
		end

		begin
			uTree = BinarySerializer.readObject("user_tweet.index")[0]
			if uTree.nil?
				@@userTweetTree = Btree.create(10) if @@userTweetTree.nil?
			else
				@@userTweetTree = uTree
			end
		rescue
			return "Arquivo de indice de tweets por usuario corrompido"
		end

		return nil
	end

	def self.getPromoTweetsFromServer(query="from:hardmob_promo OR from:achei_promocoes OR from:promocoes OR from:blackfriday", count)
	  	return Twitter.search(query, :count => count).results
	end

	def self.insertUserIfNotExist(userId, username)
		v = @@userTree[userId]
		if v.nil?
			retorno = User.factory(:twitterID => userId, :name => username)
			@@userTree[userId] = @@userTree.size
			BinarySerializer.insert("users.dat",retorno, @@userTree[userId])
		end
		return v
	end

	def self.insertTweetIfNotExist(tweetId, content, userId, username, hashtags, geo)
		v= @@tweetTree[tweetId]
		if v.nil?
			@@tweetWriteLock.synchronize {
				retorno = Tweet.factory(:twitterID => tweetId, :content => content)
				if insertUserIfNotExist(userId, username).nil?
					save("user_id.index",@@userTree)
				end

				userTweet = @@userTweetTree[username.downcase]
				if userTweet.nil?
					@@userTweetTree[username.downcase] = []
				end
				@@userTweetTree[username.downcase].push(@@tweetTree.size).sort!{|a,b| a <=> b}

				retorno.userID = userId
				retorno.username = username
				if !hashtags.nil?
					hashtags.each() do |h|
						newHash = h.text.downcase
						retorno.hashtags.push(newHash)
						hash = @@hashtagTree[newHash]
						if hash.nil?
							@@hashtagTree[newHash] = []
							newHashObject = Hashtag.factory(:text => h.text)
							BinarySerializer.append("hashtags.dat",newHashObject)
						end
							@@hashtagTree[newHash].push(@@tweetTree.size).sort! { |a,b| a <=> b }
					end
					save("hashtag_id.index",@@hashtagTree)
				end
				retorno.geo = geo
				@@tweetTree[tweetId] = @@tweetTree.size
				BinarySerializer.insert("tweets.dat",retorno, @@tweetTree[tweetId])
			}
		end
		return v
	end

	def self.updateIDtweet(array)
		if !array.empty?
			reloadTree = false
			array.each() do |tw|
				if insertTweetIfNotExist(tw.id, tw.text, tw.user.id, tw.user.name, tw.hashtags, tw.geo).nil?
					reloadTree = true
				end
			end
			if reloadTree
				save("tweet_id.index", @@tweetTree)
				save("user_tweet.index", @@userTweetTree)
			end
		end
	end

	def self.save(filePath, object)
		io = File.new(filePath, "wb")
		Marshal.dump(object, io)
		io.close()
	end
end