class PeakHoursValidator < ActiveModel::Validator

  include ActionView::Helpers::TextHelper

  def validate(record)
    unless record.date_from.blank? || record.time_from.blank?
      if record.court.peak_time?(record.date_from.wday, record.time_from)
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
      Court.peak_time?(r.court_id, r.date_from.wday, r.time_from)
    end
  end

end