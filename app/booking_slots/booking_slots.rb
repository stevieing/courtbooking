#
# 	TODO: There is a lot more that could be done to improve this module.
# 	Improving the way it is loaded.
# 	Modify the way and types of cell and row objects are created.
# 	However I have achieved the main aim which was to encapsulate all of
# 	the behaviour with minimal inputs and outputs.
# 	To display the table is just a case of outputting rows and cells.
# 	Any major internal changes should not affect this. He says!!!
# 
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
	autoload :Cell
	autoload :NullCell
	autoload :CellBuilder
	autoload :HtmlKlass

	eager_autoload do
		
		autoload :Row
		autoload :HeaderRow
		autoload :SlotRow

	end
	

	
end