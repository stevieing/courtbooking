##
# Check whether a booking overlaps with anything.
class DuplicateBookingsValidator < ActiveModel::Validator

  ##
  # This is achieved by delagating responsibility to an OverlappingRecords object.
  # If it is not empty then an error is added.
  def validate(record)
    unless OverlappingRecords.new(record).empty?
      record.errors[:base] << (options[:message] || "A booking already exists on #{record.time_and_place}")
    end
  end
end