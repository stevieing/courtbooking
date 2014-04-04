module BookingSlots
  class Records

    cattr_accessor :models, instance_accessor: false
    self.models = [:courts, :unavailable, :bookings, :activities]

    attr_reader *self.models, :properties
    delegate :events, :closures, to: :activities
    delegate :date, to: :properties

    def initialize(properties)
      @properties = properties
      create_records
    end

    def closure_message
      @unavailable.message
    end

    def remove_closed_slots!(slots)
      @unavailable.each do |closure|
        slots.reject_range!(closure.slot)
      end
    end

    def current_record(slots)
      @activities.current_record(@courts, slots) || @bookings.current_record(@courts, slots)
    end

    def valid?
      @properties.valid?
    end

    def inspect
      "<#{self.class}: @courts=#{@courts.inspect}, @unavailable=#{@unavailable.inspect}, @bookings=#{@bookings.inspect}, @activities=#{@activities.inspect}>"
    end

    def current_court_open?(slots)
      @courts.current_open?(slots.current_slot_time)
    end

    private

    def create_records
      Records.models.each do |model|
        instance_variable_set("@#{model.to_s}", "BookingSlots::#{model.to_s.capitalize}".constantize.new(@properties))
      end
    end

  end
end