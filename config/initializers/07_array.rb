class Array
	def extract_hash_keys
		self.collect{ |v| v.is_a?(::Hash) ? v.flatten.first : v}
	end
end