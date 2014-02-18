
module Slots
	class Base < Core

		include Enumerable

		attr_reader :slots, :constraints

		#TODO: quick fix while I refactor slots.
		delegate :empty?, :last, to: :slots
		delegate :slot_time, to: :constraints

		def initialize(options = {})
			@constraints = Constraints.new(options)
			@slots = create_slots
			@slots_frozen = false
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

		#TODO: must be a better way to do this?
		def collect_range(first, last)
			RangeChecker.new(first, last, self).collect
		end

		def reject_range(first, last)
			RangeChecker.new(first, last, self).reject
		end

		def reject_range!(first, last)
			RangeChecker.new(first, last, self).reject!
		end

		def valid_slot
			Pair.new(@constraints.series.find{ |slot| slot.in_the_future?}, @constraints)
		end

		def slots_between(first, last)
			RangeChecker.new(first, last, self).slots_between
		end

		def freeze_slots
			@slots_frozen = true
		end

		def slots_frozen?
			@slots_frozen
		end

		alias_method :all, :slots

		#
		# When using dup and clone ruby only copies instance variables
		# so whatever you do using the bang operator will change everything
		# down the chain.
		#

		def initialize_copy(other)
			@slots = other.slots_frozen? ? other.slots.dup : create_slots
			reset!
			super(other)
		end

		private

		def create_slots
			[].tap do |slots|
				@constraints.series.each do |slot|
					slots << Pair.new(slot, @constraints)
				end
			end
		end
	end
end