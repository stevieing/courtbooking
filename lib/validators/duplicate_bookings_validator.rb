class DuplicateBookingsValidator < ActiveModel::Validator

  def validate(record)
    unless OverlappingRecords.new(record).empty?
      record.errors[:base] << (options[:message] || "A booking already exists for #{record.time_and_place_text} on court #{record.court.number}")
    end
  end
end