module Courts
  class Grid

    include ActiveModel::Serializers::JSON

    attr_reader :closure_message, :table
    delegate :rows, :heading, to: :table

    def initialize(date, user, grid)

      @grid_processor = Courts::GridProcessor.new(date, user, grid).run!

      @closure_message = @grid_processor.closure_message
      @table = @grid_processor.table
    end

    def html_class
      "grid"
    end

    def valid?
      @closure_message && @table
    end

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