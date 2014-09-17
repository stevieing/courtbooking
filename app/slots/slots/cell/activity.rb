module Slots
  module Cell
    class Activity
      include Slots::Cell::Base

      def initialize(activity)
        @text = activity.description
        @span = activity.slot.between
        @html_class = activity.class.to_s.downcase
      end

    end

  end

end