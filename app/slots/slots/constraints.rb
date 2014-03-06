module Slots
	class Constraints

		include Slots::Helpers

		cattr_accessor :slot_first, instance_writer: false
		cattr_accessor :slot_last, instance_writer: false
		cattr_accessor :slot_time, instance_writer: false

		def self.setup
			yield self
		end

		def self.attr_accessors
			[:slot_first, :slot_last, :slot_time]
		end

		def self.new_constraint(slot_first, slot_last, slot_time)
			Constraints.new({slot_first: slot_first, slot_last: slot_last, slot_time: slot_time})
		end

		attr_accessor :slot_first, :slot_last, :slot_time
		attr_reader :series, :slot

		def initialize(options = {})
			create_instance_variables(options.symbolize_keys)
			save if valid?
		end

		# Fixed 26/02/14. This little methods was causing all sorts of failures.
		def cover?(time)
			@series.cover? time
		end

		def inspect
			"<#{self.class}: @slot_first=#{@slot_first}, @slot_last=#{@slot_last}, @slot_time=#{@slot_time}, @series=#{series.inspect}>"
		end

		def valid?
			@slot_first && slot_last && @slot_time
		end
		
		private

		def save
			@slot = Slot.new(slot_first, slot_last)
			@series = Series.new(@slot, self)
		end

		def create_instance_variables(options)
			Constraints.attr_accessors.each do |variable|
				ivar = options.empty? ? Constraints.send(variable) : to_time(options[variable])
				instance_variable_set("@#{variable.to_s}", ivar)
			end
		end

	end

end