module BookingSlots
	class CellBuilder

		attr_reader :cell

		def initialize(slots, records)
			@slots, @records = slots, records
			@cell = new_cell
			add_attributes if @cell.valid?
		end

		def valid?
			@slots.valid? && @records.valid?
		end

		def new_cell
			@slots.current_slot_valid? ? BookingSlots::Cell.new : BookingSlots::NullCell.new
		end

		def add_attributes
			unless get_record.nil?
				@cell.add(@record)
				@slots.skip(@record.span)
			end
		end

		alias_method :add, :cell

		private

		def get_record
			@record = @records.current_record(@slots)
		end

	end
end