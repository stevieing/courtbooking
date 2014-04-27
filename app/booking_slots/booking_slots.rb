#
#   TODO: There is a lot more that could be done to improve this module.
#   Improving the way it is loaded.
#   Modify the way and types of cell and row objects are created.
#   However I have achieved the main aim which was to encapsulate all of
#   the behaviour with minimal inputs and outputs.
#   To display the table is just a case of outputting rows and cells.
#   Any major internal changes should not affect this. He says!!!
#   I think it could be arranged similar to ActiveRecord where
#   the main table could be inheritied and all of the other bits and pieces
#   could be mixins.
#   The best way to attack this is to abstract out any behaviour slowly.
#   A bit more of an idea. Allow the main table to inherit the main class.
#   This would include all of the other modules.
#   These would include modules for Columns and Rows.
#   there would be class methods for rows, columns, header and footer which would relate
#   to the instance variables. These instance variables would be created by a save method.
#   There would be a create_table method which would build the rows and columns.
#   There would also be ways to find the current record.
#   I think it is best to tackle this once the app is in testing.
#
#
#   DONE: Requests times have been reduced 80% by using select and count caching.
#
module BookingSlots

  extend ActiveSupport::Autoload

  autoload :Properties
  autoload :Records
  #autoload :CurrentRecord
  autoload :TodaysSlots
  autoload :Bookings
  autoload :Unavailable
  autoload :Activities
  autoload :Courts
  autoload :Table
  autoload :Cell
  #autoload :NullCell
  autoload :HtmlKlass
  autoload :Calendar
  autoload :Dates

  eager_autoload do

    autoload :Row
    autoload :HeaderRow

  end

end