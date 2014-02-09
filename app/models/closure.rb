class Closure < Activity

	def message
		"Courts #{self.court_ids.join(',')} closed from #{self.time_from} to #{self.time_to} for #{self.description}"
	end
end