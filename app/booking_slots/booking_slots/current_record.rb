module BookingSlots

  class CurrentRecord

    attr_accessor :text, :link, :span, :klass

    def initialize(&block)
      @span = 1
      yield self if block_given?
    end

    def valid?
      !@span.nil?
    end

    def inspect
      "<#{self.class}: @text=#{@text}, @link=#{@link}, @klass=#{@klass}>"
    end

    def self.create(object, &block)
      new(&block) unless object.nil?
    end

  end
end