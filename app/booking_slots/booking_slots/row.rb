module BookingSlots

  class Row
    include Enumerable

    attr_reader :cells, :klass
    delegate :last, to: :cells

    def initialize(cells = [], klass = nil)
      @cells, @klass = cells, klass
    end

    def each(&block)
      @cells.each(&block)
    end

    def heading?
      false
    end

    def inspect
      "<#{self.class}: @heading=#{@heading}, @cells=#{@cells.each {|cell| cell.inspect}}>"
    end

    def [](index)
      @cells[index]
    end

    def valid?
      @cells.any?
    end
  end

end