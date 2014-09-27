module Slots
##
#
# = Slots::Grid
#
# this will create a grid with slots as rows and courts as columns which can be filled
# with information which can be output to a view.
# This can be stored in memory to be reused to hopefully reducing rendering times.
# Example:
#  slots (simplified): "06:00", "06:30", "07:00", "07:30"
#  courts: [<#id: 2, number: 1>, <#id: 3, number: 2>, <#id: 4, number: 3>, <#id: 5, number: 4>]
#  Slots::Grid.new(slots, courts)
# will produce:
# { header:
#   { header: <#Cell::Text text: ' '>,
#     3: <#Cell::Text text: 'Court 1'>,
#     4: <#Cell::Text text: 'Court 2'>,
#     5: <#Cell::Text text: 'Court 3'>,
#     5: <#Cell::Text text: 'Court 4'>,
#     footer: <#Cell::Text text: ' '>
#    },
#   "06:00":
#   { header: <#Cell::Text text: '06:00'>,
#     3: <#Slots::CourtSlot id: 1, from: '06:00'>,
#     4: <#Slots::CourtSlot id: 2, from: '06:00'>,
#     5: <#Slots::CourtSlot id: 3, from: '06:00'>,
#     5: <#Slots::CourtSlot id: 4, from: '06:00'>,
#     footer: <#Cell::Text text: '06:00'>
#    },
#   "06:30":
#   { header: <#Cell::Text text: '06:30'>,
#     3: <#Slots::CourtSlot id: 5, from: '06:30'>,
#     4: <#Slots::CourtSlot id: 6, from: '06:30'>,
#     5: <#Slots::CourtSlot id: 7, from: '06:30'>,
#     5: <#Slots::CourtSlot id: 8, from: '06:30'>,
#     footer: <#Cell::Text text: '06:30'>
#    },
#   "07:00":
#  { header: <#Cell::Text text: '07:00'>,
#     3: <#Slots::CourtSlot id: 9, from: '07:00'>,
#     4: <#Slots::CourtSlot id: 10, from: '07:00'>,
#     5: <#Slots::CourtSlot id: 11, from: '07:00'>,
#     5: <#Slots::CourtSlot id: 12, from: '07:00'>,
#     footer: <#Cell::Text text: '07:00'>
#    },
#   "07:30"
#  { header: <#Cell::Text text: '07:30'>,
#     3: <#Slots::CourtSlot id: 13, from: '07:30'>,
#     4: <#Slots::CourtSlot id: 14, from: '07:30'>,
#     5: <#Slots::CourtSlot id: 15, from: '07:30'>,
#     5: <#Slots::CourtSlot id: 16, from: '07:30'>,
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
#

  class Grid

    include Enumerable
    attr_reader :table, :courts
    delegate :rows, :find, :heading, to: :table

    def initialize(slots, courts)
      @slots, @courts = slots, courts
      @ids = {}
      @table = create_table
    end

    def each(&block)
      rows.each(&block)
    end

    #
    # Allow us to find a slot by its id.
    # An easier way to carry attributes through a RESTful resource.
    # A list of ids along with references to their slots are creating when
    # a new grid is created.
    #
    def find_by_id(id)
      ids[id]
    end

    def delete_rows!(slot)
      rows.delete_all(*slot.series.popped)
    end

    def unfilled
      rows.each do |row_key, row|
        unless row_key == :header || row_key == :footer
          row.each do |cell_key, cell|
            unless cell_key == :header || cell_key == :footer
              if cell.unfilled?
                yield cell if block_given?
              end
            end
          end
        end
      end
    end

    #
    # The grid will be used whenever the courts page is rendered.
    # This grid will need to be manipulated on each render
    # slots will be removed and others will be filled with Cells
    # We therefore need to dup the hashes within the grid.
    #
    def initialize_copy(other)
      @table = other.table.dup
      super(other)
    end

    def inspect
      "<#{self.class}: @rows=#{@rows.each { |r| r.inspect}}>"
    end

    def valid?
      @table
    end

  private

    attr_reader :slots, :ids

    def create_table # :nodoc:
      Table::Base.new do |table|
        table.add :header, add_header_row
        slots.each do |slot|
          table.add slot.from, add_row(slot)
        end
        table.add :footer, add_header_row
      end
    end

    def add_row(slot) # :nodoc:
      Table::Row.new do |row|
        row.add :header, Table::Cell::Text.new(slot.from)
        courts.each do |court|
          cs = CourtSlot.new(court, slot)
          row.add court.id, cs
          ids[cs.id] = cs
        end
        row.add :footer, Table::Cell::Text.new(slot.from)
      end
    end

    def add_header_row # :nodoc:
      Table::Row.new do |row|
        row.add :header, Table::Cell::Text.new
        courts.each do |court|
          row.add court.id, Table::Cell::Text.new("Court #{court.number.to_s}")
        end
        row.add :footer, Table::Cell::Text.new
      end
    end
  end

end