module Slots
	class Base

		include Enumerable

		attr_reader :slots, :constraints, :index

		delegate :empty?, :last, to: :slots
		delegate :slot_time, to: :constraints

		def initialize(options = {})
			@constraints = Slots::Constraints.new(options)
			@slots = create_slots
			@frozen = false
			reset!
		end

		def each(&block)
			@slots.each(&block)
		end

		def current
			@slots[@index]
		end

		def up(n=1)
			@index+=n
		end

		def down(n=1)
			@index-=n
		end

		def reset!
			@index = 0
		end

		def collect_range(slot)
			Slots::RangeChecker.new(slot, self).collect
		end

		def reject_range(slot)
			Slots::RangeChecker.new(slot, self).reject
		end

		def reject_range!(slot)
			Slots::RangeChecker.new(slot, self).reject!
		end

		def valid_slot
			Slots::CourtSlot.new(@constraints.series.find{ |slot| slot.in_the_future?}, @constraints)
		end

		def slots_between(slot)
			Slots::RangeChecker.new(slot, self).slots_between
		end

		def freeze
			@frozen = true
		end

		def frozen?
			@frozen
		end

		def end?
			@index >= @slots.count
		end

		def current_slot_time
			current.from
		end

		def current_time
			current.from.to_datetime
		end

		def inspect
			"<#{self.class}: @slots=#{@slots.each { |s| s.inspect}}, @frozen=#{@frozen}>"
		end

		alias_method :all, :slots

		#
		# When using dup and clone ruby only copies instance variables
		# so whatever you do using the bang operator will change everything
		# down the chain.
		#

		def initialize_copy(other)
			@slots = other.frozen? ? other.slots.dup : create_slots
			reset!
			super(other)
		end

		def valid?
			@constraints.valid? && !@slots.empty?
		end

		private

		def create_slots
			[].tap do |slots|
				@constraints.series.each do |slot|
					slots << Slots::CourtSlot.new(slot, @constraints)
				end
			end
		end
	end

end