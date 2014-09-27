module Slots

  extend ActiveSupport::Autoload

  autoload :Constraints
  autoload :Base
  autoload :RangeChecker
  autoload :Helpers
  autoload :Grid
  autoload :Series
  autoload :Cell
  autoload :Row
  autoload :CourtSlot

  eager_autoload do
    autoload :Slot
    autoload :NullObject
    autoload :ActiveRecordSlots
  end

end