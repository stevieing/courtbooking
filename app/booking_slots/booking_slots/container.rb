module BookingSlots
  module Container
    extend ActiveSupport::Concern
    include Enumerable
    include HashAttributes

    included do
      hash_attributes :cells
      delegate :last, :wrap, :cap, to: :cells
    end

    module ClassMethods
    end

    def initialize(options = {}, &block)
      set_attributes(options)
      yield self if block_given?
    end

    def each(&block)
      @cells.each(&block)
    end

    def [](index)
      @cells[index]
    end

    def valid?
      @cells.any?
    end

    def add(cell)
      @cells << cell
      return self
    end

    def inspect
      "<#{self.class}: @cells=#{@cells.each {|cell| cell.inspect}}>"
    end

  private

    def default_attributes
      { cells: [] }
    end

  end
end