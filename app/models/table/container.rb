module Table

  ##
  # A container is an element of storage.
  # At a basic level it has a single attribute cells
  # The cells attribute is a hash which can be populated
  # when the object is created or using add after.
  module Container

    extend ActiveSupport::Concern
    include Enumerable
    include ActiveModel::Serializers::JSON

    included do
      include HashAttributes
      hash_attributes cells: {}
    end

    module ClassMethods

      ##
      # This allows any classes that include Container to add new
      # attributes without adding them manually.
      # Example:
      #
      #  class Beaker
      #   include Table::Container
      #   add_attributes attr_a: "a"
      #  end
      #
      #  beaker = Beaker.new => <#Beaker: @cells: {}, @attr_a: "a">
      def add_attributes(attributes = {})
        hash_attributes attributes.merge(cells: {})
      end
    end

    delegate :empty?, to: :cells

    ##
    # Set any attributes via the options Hash
    # yield new Object if block is passed.
    # Example:
    #  beaker = Beaker.new do |b|
    #   b.add :a, "a"
    #  end
    #
    #  => <#Beaker: @cells = { a: "a"}
    #
    def initialize(options = {})
      set_attributes(options)
      yield self if block_given?
    end

    ##
    # Add a cell with a key and a value.
    def add(k,v)
      @cells[k] = v
    end

    alias_method :fill, :add

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

    def first
      @cells.values.first
    end

    def last
      @cells.values.last
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

    ##
    # Loop through each cell and run the block
    # if it is not a header
    def without_headers
      @cells.each do |key, cell|
        unless cell.header?
          yield(key, cell) if block_given?
        end
      end
    end

    ##
    # Add the cell to the start and the end of cells
    # with key header and footer
    # Example:
    #
    #  beaker = Beaker.new do |b|
    #   b.add :a, "a"
    #  end
    #
    #  beaker.top_and_tail("b") => <#Beaker: @cells = { header: "b", a: "a", footer: "b"}>
    def top_and_tail(cell)
      top(cell).tail(cell)
    end

    ##
    # Add a cell to the start of the row with key header.
    # Returns self to allow chaining.
    def top(cell)
      @cells = {header: cell}.merge(cells)
      self
    end

    ##
    # Add a cell to the end of the row with key footer.
    # Returns self to allow chaining.
    def tail(cell)
      @cells = cells.merge(footer: cell)
      self
    end

    def as_json(options = {})
      {
        cells: cells.values
      }
    end

  end

end