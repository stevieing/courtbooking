module Slots

	extend ActiveSupport::Autoload

	autoload :Constraints
	autoload :Base
	autoload :RangeChecker
	autoload :Helpers
	autoload :Grid
	autoload :Series

	eager_autoload do
		autoload :Slot
		autoload :ActivitySlot
		autoload :CourtSlot
		autoload :RecordSlot
		autoload :NullObject
		autoload :ActiveRecordSlots
	end

end