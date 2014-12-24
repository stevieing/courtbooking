module Table
  ##
  # This is a general utility class allowing a table to be constructed for use in creating HTML tables.
  #
  # The rows and cells are type agnostic although each row is better as a Row class.If anything else
  # is used it will need to implement a find method.
  #
  # The table is constructed as a hash which improves performance as well as making things easier to find.
  #
  # Example:
  #  table = Table.new do |table|
  #   table.add "1", Row.new(...)
  #  end
  #
  class Base

    include Table::Container
    add_attributes heading: ""

    alias_attribute :rows, :cells

    ##
    # Find the rows and cells by their keys:
    # * If only the row key is provided it will return the row ro nil.
    # * If the row and column key exists then the row will be searched.
    #
    def find(r,c=nil)
      row = rows[r]
      return row unless row && c
      row.find(c)
    end

    ##
    # Return an array of empty cells.
    def unfilled
      rows.values.collect { |row| row.empty_cells }.flatten
    end

    ##
    # Find the row r. Fill cell c with cell.
    def fill(r,c,cell)
      find(r).fill(c,cell)
    end

    def inspect
      "<#{self.class}: @rows=#{rows.each { |r| r.inspect}}, @heading=#{heading}>"
    end

    ##
    # Delete the rows with the specified keys.
    def delete_rows!(*rows)
      @cells.delete_all(*rows)
    end

    ##
    # Close all of the specified cells i.e.
    # Set the cell to an instance of Cell::Closed
    def close_cells!(rows, cell)
      rows.each { |row| fill(row, cell, Cell::Closed.new)}
    end

    ##
    # Set the html class for each of the specified rows.
    def set_row_class(rows, klass)
      rows.each { |row| find(row).html_class = klass }
    end

    ##
    # Example:
    #
    def as_json(options = {})
      {
        heading: heading,
        rows: rows.values
      }
    end


  end
end