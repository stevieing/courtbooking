module Slots
	class Core
		def convert!(time)
			time.instance_of?(Time) ? time : Time.parse(time)
		end
	end
end