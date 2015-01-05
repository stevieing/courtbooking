module Slots

  ###
  #
  # this will create a grid with slots as rows and courts as columns which can be filled
  # with information which can be output to a view.
  # This can be stored in memory to be reused to hopefully reducing rendering times.
  # Example:
  #  slots (simplified): "06:00", "06:30", "07:00", "07:30"
  #  courts: [<#id: 2, number: 1>, <#id: 3, number: 2>, <#id: 4, number: 3>, <#id: 5, number: 4>]
  #  Slots::Grid.new(slots, courts)
  # will produce:
  #  { header:
  #   { header: <#Cell::Text text: ' '>,
  #     3: <#Cell::Text text: 'Court 1'>,
  #     4: <#Cell::Text text: 'Court 2'>,
  #     5: <#Cell::Text text: 'Court 3'>,
  #     5: <#Cell::Text text: 'Court 4'>,
  #     footer: <#Cell::Text text: ' '>
  #    },
  #   "06:00":
  #   { header: <#Cell::Text text: '06:00'>,
  #     3: <#Slots::Cell::Empty>,
  #     4: <#Slots::Cell::Empty>,
  #     5: <#Slots::Cell::Empty>,
  #     5: <#Slots::Cell::Empty>,
  #     footer: <#Cell::Text text: '06:00'>
  #    },
  #   "06:30":
  #   { header: <#Cell::Text text: '06:30'>,
  #     3: <#Slots::Cell::Empty>,
  #     4: <#Slots::Cell::Empty>,
  #     5: <#Slots::Cell::Empty>,
  #     5: <#Slots::Cell::Empty>,
  #     footer: <#Cell::Text text: '06:30'>
  #    },
  #   "07:00":
  #  { header: <#Cell::Text text: '07:00'>,
  #     3: <#Slots::Cell::Empty>,
  #     4: <#Slots::Cell::Empty>,
  #     5: <#Slots::Cell::Empty>,
  #     5: <#Slots::Cell::Empty>,
  #     footer: <#Cell::Text text: '07:00'>
  #    },
  #   "07:30"
  #  { header: <#Cell::Text text: '07:30'>,
  #     3: <#Slots::Cell::Empty>,
  #     4: <#Slots::Cell::Empty>,
  #     5: <#Slots::Cell::Empty>,
  #     5: <#Slots::Cell::Empty>,
  #     footer: <#Cell::Text text: '07:30'>
  #    },
  #   footer:
  #   { header: <#Cell::Text text: ' '>,
  #     3: <#Cell::Text text: 'Court 1'>,
  #     4: <#Cell::Text text: 'Court 2'>,
  #     5: <#Cell::Text text: 'Court 3'>,
  #     5: <#Cell::Text text: 'Court 4'>,
  #     footer: <#Cell::Text text: ' '>
  #    }
  # }
  class Grid

    attr_reader :table, :courts, :series, :constraints
    delegate :rows, :find, :heading, :fill, :unfilled, to: :table

    def initialize(options = {})
      @courts = options.delete(:courts)
      @constraints = Constraints.new(options)
      @series = constraints.series
      @court_slots = CourtSlots.new(courts, constraints.slots)
      @table = create_table
    end

    #
    # Allow us to find a slot by its id.
    # An easier way to carry attributes through a RESTful resource.
    # A list of ids along with references to their slots are creating when
    # a new grid is created.
    def find_by_id(id)
      @court_slots.find_by_id(id)
    end

    ##
    # Remove any specified slots from the series.
    # Delete any associated rows from the table.
    def remove_slots!(slots)
      series.remove!(slots)
      table.delete_rows!(*slots)
    end

    #
    # This will close the slots
    # i.e. add a Closed cell to the table for each slot that is closed
    # If the series is empty then all of the slots
    # will be closed for that court.
    def close_court_slots!(day)
      courts.each do |court|
        opening_times = court.opening_times.by_day(day)
        slots = series.except(Slot.combine_series(opening_times.slots))
        table.close_cells! slots, court.id
      end
    end

    #
    # The grid will be used whenever the courts page is rendered.
    # This grid will need to be manipulated on each render
    # slots will be removed and others will be filled with Cells
    # We therefore need to ensure that the court slots are dupped properly.
    def initialize_copy(other)
      @series = other.series.dup
      @table = other.table.dup
      super(other)
    end

    def inspect
      "<#{self.class}: @table=#{@table.inspect}>"
    end

    ##
    # The grid will be valid if the table is created.
    def valid?
      @table
    end

    ##
    # For each row which is in the past add a class "past"
    def add_class_to_rows_in_past(date)
      table.set_row_class(series.past(date), "past")
    end

    ##
    # Add a heading to the table.
    def add_heading(heading)
      table.heading = heading
    end

    def except_last
      @except_last ||= constraints.slots_from
    end

    def except_first
      @except_first ||= constraints.slots_to
    end

  private

    def create_table
      @court_slots.to_empty.tap do |t|
        t.rows.each do |r, row|
          row.top_and_tail(Table::Cell::Text.new(text: r))
        end
      end.top_and_tail(add_header_row)
    end

    def add_header_row # :nodoc:
      Table::Row.build_header(@courts).top_and_tail(Table::Cell::Text.new(header: true))
    end

  end

end