module Slots
	class Grid

		include Enumerable

		attr_accessor :objects
		attr_reader :original
		delegate :frozen?, :up, :current_slot_time, :current, :end?, to: :original
		
		def initialize(number, original)
			@number, @original = number, original
			@objects = create_objects
		end

		def each(&block)
			@objects.each(&block)
		end

		def [](key)
			@objects[key]
		end

		def valid?
			@objects.all? { |o| o.valid? }
		end

		def synced?(index)
			@original.current == @objects[index].current
		end

		def inspect
			"<#{self.class}: @number=#{@number}, @original=#{@original.inspect}}>"
		end

		def skip(index, by)
			@objects[index].up(by)
		end

		private

		def create_objects
			[].tap do |o|
				(1..@number).each do |i|
					o << @original.dup
				end
			end
		end
	end


end