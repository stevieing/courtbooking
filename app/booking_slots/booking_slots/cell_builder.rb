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
				@cell.add do |c|
					c.span = @record.slot.between
					@slots.skip(@courts.index, @record.slot.between)
					set_text_and_link(c)
				end
			end
		end

		private

		def get_record
			@record = @records.current_record(@courts, @slots)
		end

		def set_text_and_link(c)
			if @record.is_a? Activity
				c.text 		= @record.description
			else
			end
		end

	end
end