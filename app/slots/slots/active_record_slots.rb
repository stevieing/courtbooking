
module Slots
	module ActiveRecordSlots

		extend ActiveSupport::Concern

		included do
			add_slots_method
		end

		module ClassMethods
			def add_slots_method
				define_method :slot do
					@slot ||= create_slot
				end
			end
		end

		#
		# TODO: I'm sure there must be a better way of doing this!
		# TODO: solve autoloading problem.
		#

		def create_slot
			if self.instance_of?(Booking)
				Slots::RecordSlot.new(self.time_from, self.time_to)
			elsif self.class.superclass == Activity
				Slots::ActivitySlot.new(self.time_from, self.time_to, Settings.slots.constraints)
			else
				Slots::Slot.new(self.time_from, self.time_to)
			end
		end
	end
end