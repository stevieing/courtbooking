module Courts

  ##
  # This is essentially an entry point for an api.
  # It doesn't do that much.
  # It processes the grid and returns the table.
  # It also implements the json method and will
  # return the results to any json request.
  class Grid

    include ActiveModel::Serializers::JSON

    ##
    # The message signifying why all the courts are closed.
    attr_reader :closure_message

    ##
    # The table that will create the view.
    # Copied from CourtSlots.
    attr_reader :table

    delegate :rows, :heading, to: :table

    ##
    # Creates a new GridProcessor runs it and creates instances of
    # the closure message and the table.
    def initialize(date, user, grid)

      @grid_processor = Courts::GridProcessor.new(date, user, grid).run!

      @closure_message = @grid_processor.closure_message
      @table = @grid_processor.table
    end

    ##
    # Adds a basic class for use within the app.
    # Not passed to any api.
    def html_class
      "grid"
    end

    ##
    # Allows for a Factory to be created.
    # It is valid as long as closure message and
    # table are present.
    def valid?
      @closure_message && @table
    end

    ##
    # Produces a root element "courts_grid"
    # and an element for the closure_message and the table.
    # The to_json for table will be called.
    def as_json(options = {})
      {
        courts_grid:
        {
          closure_message: closure_message,
          table: table
        }
      }
    end

  end

end