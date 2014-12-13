module Slots
  module Helpers

    #
    # It is possible that some classes may receive a hh:mm time as
    # a string or a time. If it is a string it is converted to a time
    # otherwise it is left untouched.
    #
    def to_time(attribute)
      case attribute
        when String then Time.parse(attribute)
        else attribute
      end
    end

    #
    # Takes a start time and an end time and constructs all of the slots inbetween
    # based on the slot time.
    # For example to_range(06:20, 12:20, 40)
    # would return ["06:20", "07:00", "07:40", "08:20", "09:00", "09:40", "10:20", "11:00", "11:40", "12:20"]
    #
    #
    def to_range(from, to, step)
      to_time(from).to(to_time(to), step.minutes).collect { |t| t.to_s(:hrs_and_mins)} if step > 0
    end
  end
end
