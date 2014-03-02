module BookingSlots

	extend ActiveSupport::Autoload

	autoload :Properties
	autoload :Records
	autoload :CurrentRecord
	autoload :TodaysSlots
	autoload :Bookings
	autoload :Unavailable
	autoload :Activities
	autoload :Courts
	autoload :Table
	autoload :Row
	autoload :HeaderRow, 		'booking_slots/row'
	autoload :SlotRow,			'booking_slots/row'
	autoload :Cell
	autoload :NullCell,			'booking_slots/cell'
	autoload :CellBuilder
	
end