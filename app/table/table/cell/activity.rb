module Table

  #
  # = Table::Cell::Activity
  #
  #  The cell type used for closures and events.
  #  An activity will normally span several cells.
  #  If it is the first slot for the activity
  #  i.e. activity time from.
  #  then we need to output the type of activity.
  #  plus the number of slots the activity spans.
  #  If it is not the first slot then we need to fake
  #  a blank cell.
  #
  module Cell
    class Activity
      include Table::Cell::Base

      def initialize(activity, slot_time)
        @blank = (activity.time_from != slot_time)
        unless blank?
          @text = activity.description
          @span = activity.slot.between
        else
          @span = 1
        end
        @html_class = activity.class.to_s.downcase
      end

      def blank?
        @blank
      end

    end

  end

end