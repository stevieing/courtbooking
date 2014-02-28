module BookingSlots
	class Table

		include Enumerable

		attr_reader :rows, :records
		delegate :last, to: :rows
		delegate :closure_message, to: :records

		def initialize(date, user, slots)
			@date, @slots = date, slots
			@properties = Properties.new(date, user)
			@records = Records.new(@properties)
			@todays_slots = TodaysSlots.new(slots.dup, @records)
			setup_table
		end

		def each(&block)
			@rows.each(&block)
		end

		def inspect
			"<#{self.class}: @date=#{@date}, @rows=#{@rows.each {|row| row.inspect}}>"
		end

		private

		def setup_table
			@rows = create_rows.wrap(HeaderRow.new(@records.courts))
		end

		def create_rows
			[].tap do |rows|
				until @todays_slots.end?
					rows << SlotRow.new(@todays_slots, @records)
					@todays_slots.up
				end
			end
		end

	end
end