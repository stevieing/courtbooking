module Table
  ###
  # This is a general utility class allowing a table to be constructed for use in creating HTML tables.
  #
  # The rows and cells are type agnostic although each row is better as a Row class.If anything else
  # is used it will need to implement a find method.
  #
  # The table is constructed as a hash which improves performance as well as making things easier to find.
  #
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

    def unfilled
      without_headers do |k, row|
        row.without_headers do |c, cell|
          if cell.empty?
            yield cell if block_given?
          end
        end
      end
    end

    def fill(r,c,cell)
      find(r).fill(c,cell)
    end

    def inspect
      "<#{self.class}: @rows=#{rows.each { |r| r.inspect}}, @heading=#{heading}>"
    end

    def delete_rows!(*rows)
      @cells.delete_all(*rows)
    end

    def close_cells!(rows, cell)
      rows.each { |row| fill(row, cell, Cell::Closed.new)}
    end

    def set_row_class(rows, klass)
      rows.each { |row| find(row).html_class = klass }
    end

  end
end