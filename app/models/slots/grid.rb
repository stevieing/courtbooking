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

    attr_reader :table, :courts
    delegate :rows, :find, :heading, :fill, to: :table

    def initialize(slots, courts)
      @courts = courts
      @court_slots = CourtSlots.new(courts, slots)
      @table = create_table
    end

    #
    # Allow us to find a slot by its id.
    # An easier way to carry attributes through a RESTful resource.
    # A list of ids along with references to their slots are creating when
    # a new grid is created.
    #
    def find_by_id(id)
      @court_slots.find_by_id(id)
    end

    def delete_rows!(slot)
      table.delete_rows!(*slot.series.popped)
    end

    #
    # This will close the slots
    # i.e. add a Closed cell to the CellSlot
    # If the series is empty then all of the slots
    # will be closed for that court.
    #
    def close_court_slots!(day, series)
      courts.each do |court|
        opening_times = court.opening_times.by_day(day)
        if opening_times.empty?
          close_slots! series.all, court
        else
          opening_times.each do |opening_time|
            close_slots! series.except(opening_time.slot.series), court
          end
        end
      end
    end

    #
    # This will add the bookings to the appropriate slots
    # and then add new bookings to the rest of them which are unfilled.
    #
    def add_bookings!(bookings, user, date)
      table.unfilled do |empty|
        fill(empty.slot.from, empty.slot.court_id, select_booking(bookings, user, date, empty.slot))
      end
    end

    def add_activities!(activities)
      activities.each do |activity|
        activity.slot.series.popped.each do |time|
          activity.courts.each do |court|
            fill(time, court.id, Table::Cell::Activity.new(activity,time))
          end
        end
      end
    end

    #
    # The grid will be used whenever the courts page is rendered.
    # This grid will need to be manipulated on each render
    # slots will be removed and others will be filled with Cells
    # We therefore need to ensure that the court slots are dupped properly.
    #
    def initialize_copy(other)
      @table = other.table.dup
      super(other)
    end

    def inspect
      "<#{self.class}: @table=#{@table.inspect}>"
    end

    def valid?
      @table
    end

  private

    def close_slots!(slots, court)
      slots.each do |slot|
        fill(slot, court.id, Table::Cell::Closed.new)
      end
    end

    def select_booking(bookings, user, date, slot)
      Table::Cell::Booking.new(
      bookings.select_first_or_initialize(time_from: slot.from, court: slot.court) do |booking|
        booking.date_from = date
        booking.user = user
        booking.slot = slot
      end)
    end

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