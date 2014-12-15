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

    #
    # This will construct a header row from an array of objects.
    # The objects must implement the key and heading methods.
    # The key will represent the hash key and the heading will represent
    # the text.
    # For example:
    #  Header = Struct.new(:id, :heading)
    #  headers = [Header.new(1,"a"), Header.new(2,"b"), Header.new(3,"c"), Header.new(4, "d")]
    #  row = Table::Row.build_header(headers)
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