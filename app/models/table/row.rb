module Table

  ##
  # A row can make up the table.
  # Made of a HTML class and cells.
  # The cells can be added in the constructor.
  # Example:
  #   row = Row.new do |row|
  #     row.add "1", Cell.new
  #   end
  #
  # the available attributes are cells, html_class and header
  class Row

    include Enumerable
    include HashAttributes


    hash_attributes :cells, :html_class, :header

    delegate :empty?, to: :cells

    attr_accessor :html_class, :header

    ##
    # Set any attributes via the options Hash
    # yield new Object if block is passed.
    def initialize(options = {})
      set_attributes(options)
      yield self if block_given?
    end

    ##
    # each is run for the cells attribute
    def each(&block)
      @cells.each(&block)
    end

    ##
    # Find a cell based on its key
    def find(k)
      @cells[k]
    end

    ##
    # Add a cell with a key and a value.
    def add(k,v)
      @cells[k] = v
    end

    def inspect
      "<#{self.class}: @cells=#{@cells.each { |c| c.inspect}}, @html_class=#{html_class}>"
    end

    ##
    # Loop through each cell and run the block
    # if it is not a header
    def without_headers
      cells.each do |key, cell|
        unless cell.header?
          yield cell if block_given?
        end
      end
    end

    ##
    # Is the row a header row.
    def header?
      @header
    end

    ##
    # Create a new Hash for the cells and dup each cell
    # and add it to the Hash.
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