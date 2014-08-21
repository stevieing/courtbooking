require "test_helper"

class EventFormTest < ActiveSupport::TestCase

  def setup
    create_list(:court, 4)
    @event_form = EventForm.new
  end

  test "event should be created with valid attributes" do
    @event_form.submit(attributes_for(:event).merge(court_ids: Court.pluck(:id)))
    assert @event_form.valid?
    assert_equal 1, Event.count
  end

  test "event should not be created with invalid attributes" do
    @event_form.submit(attributes_for(:event))
    refute @event_form.valid?
    assert Event.all.empty?
  end

  test "event should be updated with valid attributes" do
    @event_form = EventForm.new(create(:event))
    @event_form.submit(attributes_for(:event).merge(court_ids: Court.pluck(:id).drop(1)))
    assert @event_form.valid?
    assert_equal 1, Event.count
  end

  test "event should be created when overlapping records are allowed to be removed" do
    create(:event, court_ids: Court.pluck(:id))
    @event_form.submit(attributes_for(:event).merge(court_ids: Court.pluck(:id), allow_removal: true))
    assert @event_form.valid?
    assert_equal 1, Event.count
  end

  test "event should not be created when overlapping records are not allowed to be removed" do
    create(:event, court_ids: Court.pluck(:id))
    @event_form.submit(attributes_for(:event).merge(court_ids: Court.pluck(:id)))
    refute @event_form.valid?
    assert_equal 1, Event.count
  end

end