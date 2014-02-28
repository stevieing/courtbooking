module Slots
	extend ActiveSupport::Autoload

	autoload :Constraints
	autoload :Base
	autoload :RangeChecker
	autoload :Helpers
	autoload :Slot
	autoload :Grid
	autoload :ActiveRecordSlots
	autoload :ActivitySlot,				'slots/slot'
	autoload :CourtSlot, 					'slots/slot'
	autoload :RecordSlot, 				'slots/slot'
	autoload :NullObject, 				'slots/base'

	
	

	# eager_autoload do
		
	# end

	# def self.eager_load!
	# 	super
	# 	Slots::Slot.eager_load!
	# end

end