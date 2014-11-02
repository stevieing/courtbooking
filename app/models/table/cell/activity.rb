module Table

  module Cell
    ##
    #  The cell type used for closures and events.
    #  An activity will normally span several cells.
    #  If it is the first slot for the activity
    #  i.e. activity time from.
    #  then we need to output the type of activity.
    #  plus the number of slots the activity spans.
    #  If it is not the first slot then we need to fake
    #  a blank cell.
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

      def to_html(tag = :td)
        blank? ? nil : super(tag)
      end

    end

  end

end