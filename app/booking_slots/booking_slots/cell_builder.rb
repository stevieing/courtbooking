module BookingSlots
	class CellBuilder

		attr_reader :cell

		def initialize(slots, records)
			@slots, @records, @courts = slots, records, records.courts
			@cell = new_cell
			add_attributes if @cell.valid?
		end

		def valid?
			@slots.valid? && @records.valid?
		end

		def new_cell
			@slots.synced?(@courts.index) ? Cell.new : NullCell.new
		end

		#TODO: this is obviously going to be the heart of the matter and may need refactoring.
		def add_attributes
			unless get_record.nil?
				@cell.add(@record)
				@slots.skip(@courts.index, @record.span)
			end
		end

		alias_method :add, :cell

		private

		def get_record
			@record = @records.current_record(@slots)
		end

	end
end