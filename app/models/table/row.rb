module Table

  #
  # = Table::Row
  #
  #  A row can make up the table.
  #  Made of a HTML class and cells.
  #  The cells can be added in the constructor.
  #  row = Row.new do |row|
  #    row.add "1", Cell.new
  #  end
  #

  class Row
    include Enumerable
    include HashAttributes

    hash_attributes :cells, :html_class, :header
    delegate :empty?, to: :cells

    def initialize(options = {})
      set_attributes(options)
      yield self if block_given?
    end

    def each(&block)
      @cells.each(&block)
    end

    #
    # Find a cell based on its key
    #
    def find(k)
      @cells[k]
    end

    #
    # Add a cell with a key and a value.
    # Can be chained.
    #
    def add(k,v)
      @cells[k] = v
    end

    def html_class=(klass)
      @html_class = klass
    end

    def header=(header)
      @header = header
    end

    def inspect
      "<#{self.class}: @cells=#{@cells.each { |c| c.inspect}}, @html_class=#{html_class}>"
    end

    def without_headers
      cells.each do |key, cell|
        unless cell.header?
          yield cell if block_given?
        end
      end
    end

    def header?
      @header
    end

    def initialize_copy(other)
      @cells = {}
      other.cells.each do |k, cell|
        @cells[k] = cell.dup
      end
      super(other)
    end

  private

    def default_attributes
      { html_class: nil, cells: {}, header: false }
    end
  end
end