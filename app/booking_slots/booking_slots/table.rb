module BookingSlots
	class Table

		include Enumerable
		include BookingSlots::Wrapper

		attr_reader :rows, :records
		delegate :last, to: :rows
		delegate :closure_message, to: :records

		def initialize(date, user, slots)
			@date, @slots = date, slots
			@properties = Properties.new(date, user)
			@records = Records.new(@properties)
			@todays_slots = TodaysSlots.new(slots.dup, @records)
			@rows = create_rows
		end

		def each(&block)
			@rows.each(&block)
		end

		def heading
			@properties.date.to_s(:uk)
		end

		def inspect
			"<#{self.class}: @date=#{@date}, @rows=#{@rows.each {|row| row.inspect}}>"
		end

		private

		def wrapper
			HeaderRow.new(@records.courts.header)
		end

		def create_rows
			[].tap do |rows|
				until @todays_slots.end?
					rows << SlotRow.new(@todays_slots, @records)
					@todays_slots.up
				end
			end
		end

		wrap :create_rows, :wrapper

	end
end