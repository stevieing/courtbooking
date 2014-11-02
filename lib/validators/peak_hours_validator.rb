##
# Check whether a record violates the maximum number of
# peak hours records for a particular day or week.
# Two constant values are needed:
# * Maximum number of of peak hours bookings for a day
# * Maximum number of peak hours bookings for a week
class PeakHoursValidator < ActiveModel::Validator

  include ActionView::Helpers::TextHelper

  ##
  # * If the date_from time_from and court are blank then validation is not run
  # * If the record occurs within a peak time then the validation is run.
  # * If the record causes the number of peak hours records to exceed the maximum number for that day then an error is added.
  # * If the record causes the number of peak hours records to exceed the maximum number for that week then an error is added.
  def validate(record)
    unless record.date_from.blank? || record.time_from.blank? || record.court.nil?
      if record.court.peak_time?(record.date_from.cwday-1, record.time_from)
        add_error user_records_for_day(record), record, Settings.max_peak_hours_bookings_daily, "day"
        add_error user_records_for_week(record), record, Settings.max_peak_hours_bookings_weekly, "week"
      end
    end
  end

private

  def add_error(records, record, max_bookings, period)
    if find_peak_hours_records(records).length >= max_bookings
      record.errors[:base] << (options[:message] ||
      "No more than #{pluralize(max_bookings, "booking")} allowed during peak hours in the same #{period}.")
    end
  end

  def user_records_for_day(record)
    user_records(record, record.date_from)
  end

  def user_records_for_week(record)
    user_records(record, record.date_from.beginning_of_week..record.date_from.end_of_week)
  end

  def user_records(record, condition)
    record.class.where(user_id: record.user_id, date_from: condition)
  end

  def find_peak_hours_records(records)
    records.select do |r|
      Court.peak_time?(r.court_id, r.date_from.cwday-1, r.time_from)
    end
  end

end