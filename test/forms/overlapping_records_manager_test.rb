require "test_helper"

class OverlappingRecordsManagerTest < ActiveSupport::TestCase

  class MyModel
    include ActiveModel::Model
    include OverlappingRecordsManager
    attr_accessor :date_from, :time_from, :time_to, :court_id

    validate :verify_overlapping_records_removal
    def initialize(*args)
      @allow_removal = true
      super
    end

    alias_attribute :date_to, :date_from

    def court_ids
      [@court_id]
    end
  end

  attr_reader :booking, :closure, :event

  def setup
    stub_dates("26 March 2014", "19:00")
    stub_settings
    @booking = create(:booking, date_from: Date.today+1)
    @closure = create(:closure)
    @event = create(:event)
    OverlappingRecords.any_instance.stubs(:get_records).returns(Booking.all+Activity.all)
  end

  test "If there are any overlapping records they should be removed and send an email if they include a booking" do
    MyModel.new(date_from: Date.today+1, time_from: "19:00", time_to: "20:00", court_id: 1).remove_overlapping
    assert Booking.all.empty?
    assert Activity.all.empty?
    refute ActionMailer::Base.deliveries.empty?
  end

  test "If allow removal is false the records should not be removed and an appropriate error message is returned" do
    my_model = MyModel.new(date_from: Date.today+1, time_from: "19:00", time_to: "20:00", court_id: 1)
    my_model.allow_removal = false
    my_model.remove_overlapping
    refute my_model.valid?
    assert my_model.errors.full_messages.include?("There are records which are affected by this submission. Please approve their removal before continuing.")
    refute Booking.all.empty?
    refute Activity.all.empty?
  end

end