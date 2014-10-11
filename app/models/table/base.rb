module Table

  #
  # = Table::Base
  #  This is a general utility class allowing a table to be constructed.
  #  for use in creating HTML tables.
  #  The rows and cells are type agnostic.
  #  Although each row is better as a Row class.
  #  If anything else is used it will need to implement a find method.
  #  The table is constructed as a hash.
  #  This improves performance as well as making things easier to find.
  #  The initializer has a yield allowing you to add stuff to the table in a block.
  #   e.g.
  #   table = Table.new do |table|
  #     table.add "1", Row.new(...)
  #   end
  #
  class Base

    include Enumerable
    include HashAttributes

    hash_attributes :rows, :heading

    def initialize(options = {})
      set_attributes(options)
      yield self if block_given?
    end

    def each(&block)
      @rows.each(&block)
    end

    #
    # Add a new row to the table with a key and value
    #
    def add(k,v)
      @rows[k] = v
    end

    #
    # Gives you the ability to add the header after the fact.
    #
    def heading=(heading)
      @heading = heading
    end

    #
    # Find the rows and cells by their keys.
    # If only the row key is provided it will return the row ro nil.
    # If the row and column key exists then the row will be searched.
    #
    def find(r,c=nil)
      row = @rows[r]
      return row unless row && c
      row.find(c)
    end

    #
    # Again the table may need to copied and modified.
    # The deep dup is necessary as each row may also
    # contain a Hash.
    #
    def initialize_copy(other)
      @rows = other.rows.deep_dup
      super(other)
    end

    def without_headers
      rows.each do |key, row|
        unless row.header?
          yield row if block_given?
        end
      end
    end

    def inspect
      "<#{self.class}: @rows=#{@rows.each { |r| r.inspect}}, @heading=#{heading}>"
    end

  private

    def default_attributes
      { heading: "", rows: {} }
    end

  end

end