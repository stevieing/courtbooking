##
# Returns an ActiveRecord::Relation of closures which affect all of the courts
# for the specified day.
# Creates a combined message for all of the closures which
# can be output as a string.
#

module BookingSlots
  class Unavailable
    include Enumerable

    attr_reader :closures, :message

    def initialize(properties)
      @properties   = properties
      @closures     = get_closures
      @message      = create_message
    end

    def each(&block)
      @closures.each(&block)
    end

    def get_closures
      Court.closures_for_all_courts(@properties.date)
    end

    def inspect
      "<#{self.class}: @closures=#{@closures.inspect}, @message=#{@message.to_s}>"
    end

    def valid?
      @properties.valid?
    end

  private

    def create_message
      @closures.inject(String.new) { |message, closure| message << closure.message }
    end

  end
end