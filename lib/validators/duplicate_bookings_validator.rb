class DuplicateBookingsValidator < ActiveModel::Validator

  def validate(record)
    unless OverlappingRecords.new(record).empty?
      record.errors[:base] << (options[:message] || "A booking already exists on #{record.time_and_place}")
    end
  end
end