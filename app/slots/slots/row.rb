module Slots
  class Row
    include Enumerable
    include HashAttributes

    hash_attributes :cells, :html_class
    delegate :empty?, to: :cells

    def initialize(options = {})
      set_attributes(options)
      yield self if block_given?
    end

    def each(&block)
      cells.each(&block)
    end

    def find(k)
      cells[k]
    end

    def add(k,v)
      cells[k] = v
      self
    end

    def html_class=(klass)
      @html_class = klass
    end

    def inspect
      "<#{self.class}: @cells=#{@cells.each { |c| c.inspect}}, @html_class=#{html_class}>"
    end

  private

    def default_attributes
      { html_class: nil, cells: {} }
    end
  end
end