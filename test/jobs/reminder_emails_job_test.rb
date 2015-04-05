require 'test_helper'

class ReminderEmailsJobTest < ActiveJob::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    stub_dates("16 September 2013", "09:00")
    stub_settings
  end

  test "emails should be sent" do
    courts = create_list(:court_with_opening_and_peak_times, 4)
    create(:booking, court: courts.first, date_from: Date.today, time_from: "11:00", time_to: "11:30")
    create(:booking, court: courts[1], date_from: Date.today, time_from: "11:00", time_to: "11:30")
    create(:booking, court: courts[2], date_from: Date.today, time_from: "11:00", time_to: "11:30")

    ReminderEmailsJob.perform_now

    assert_equal 3, ActionMailer::Base.deliveries.size

  end
end
