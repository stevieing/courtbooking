module OverlappingRecordsManager

  extend ActiveSupport::Concern

  included do
    attr_accessor :allow_removal
    define_method :overlapping_object do
      self
    end
  end

  module ClassMethods
    def overlapping_object(object)
      define_method :overlapping_object do
        send(object)
      end
    end
  end

  def allow_removal?
    @allow_removal
  end

  def overlapping_records
    @overlapping_records ||= OverlappingRecords.new(overlapping_object)
  end

  def remove_overlapping
    if valid?
      overlapping_records.records.each do |record|
        BookingMailer.booking_cancellation(record).deliver_now if record.is_a?(Booking)
        record.class.destroy(record.id)
      end
    end
  end

  def verify_overlapping_records_removal
    unless allow_removal?
      if overlapping_records.any?
        errors[:base] << "There are records which are affected by this submission. Please approve their removal before continuing."
      end
    end
  end

end