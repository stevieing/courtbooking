module Slots
  module Helpers
    def to_time(attribute)
      case attribute
        when String then Time.parse(attribute)
        else attribute
      end
    end

    def to_range(from, to, step)
      to_time(from).to(to_time(to), step.minutes).collect { |t| t.to_s(:hrs_and_mins)}
    end
  end
end
