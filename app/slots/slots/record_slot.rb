module Slots
	class RecordSlot < Slot
		def initialize(from, to)
			super(from, to)
			save if valid?
		end

		private

		def save
			@series = Slots::Series.new(self, NullObject.new)
		end
	end
end