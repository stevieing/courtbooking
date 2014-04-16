#
# TODO: This needs to be expanded to cover all eventualities.
#

module BookingSlots
  class HtmlKlass

    def initialize(object)
      @object = object
      @klass  = get_klass
    end

    def value
      @klass.empty? ? nil : @klass
    end

    private

    def get_klass
      @object.instance_of?(DateTime) ? in_the_past : @object.class.to_s.downcase
    end

    def in_the_past
      @object.in_the_past? ? "past" : ''
    end
  end
end