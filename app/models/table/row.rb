module Table
  ##
  # A row can make up the table.
  # Made of a HTML class and cells.
  # The cells can be added in the constructor.
  # Example:
  #  row = Row.new do |row|
  #   row.add "1", Cell.new
  #  end
  #
  # the available attributes are cells, html_class and header
  class Row

    include Table::Container

    add_attributes html_class: nil, header: false

    def self.build_header(objects)
      Row.new(header: true) do |row|
        objects.each do |object|
          row.add object.id, Cell::Text.new(text: object.heading, header: true)
        end
      end
    end

    def inspect
      "<#{self.class}: @cells=#{@cells.each { |c| c.inspect}}, @html_class=#{html_class}>"
    end

    ##
    # Is the row a header row.
    def header?
      @header
    end

  end
end