module Slots
	class Constraints < Core

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
		attr_reader :series

		def initialize(options = {})
			create_instance_variables(options.symbolize_keys)
			@series = Series.new(slot_first, slot_last, slot_time)
		end

		def cover?(time)
			range.cover? time
		end

		def inspect
			"<#{self.class}: @slot_first=#{@slot_first}, @slot_last=#{@slot_last}, @slot_time=#{@slot_time}, @series=#{series.inspect}>"
		end
		
		private

		def range
			@slot_first..@slot_last
		end

		def create_instance_variables(options)
			Constraints.attr_accessors.each do |variable|
				instance_variable_set("@#{variable.to_s}", convert!(options[variable]) || Constraints.send(variable))
			end
		end

		def convert!(variable)
			if variable.instance_of?(String)
				variable.valid_time? ? variable.to_time : variable
			else
				variable
			end
		end
	end
end