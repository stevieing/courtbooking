module BookingSlots

  class Row
    include Container

    hash_attributes :heading, :klass

    def heading?
      @heading
    end

    def inspect
      "<#{self.class}: @heading=#{@heading},  @klass=#{@klass}, @cells=#{@cells.each {|cell| cell.inspect}}>"
    end

  private

    def default_attributes
      super.merge(klass: nil, heading: false)
    end
  end

end