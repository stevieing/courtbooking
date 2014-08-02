require "test_helper"

class EventsFormTest < ActiveSupport::TestCase

  def setup
    create_list(:court, 4)
    @events_form = EventsForm.new
  end

  test "event should be created with valid attributes" do
    @events_form.submit(attributes_for(:event).merge(court_ids: Court.pluck(:id)))
    assert @events_form.valid?
    assert_equal 1, Event.count
  end

  test "event should not be created with invalid attributes" do
    @events_form.submit(attributes_for(:event))
    refute @events_form.valid?
    assert Event.all.empty?
  end

  test "event should be updated with valid attributes" do
    @events_form = EventsForm.new(create(:event))
    @events_form.submit(attributes_for(:event).merge(court_ids: Court.pluck(:id).drop(1)))
    assert @events_form.valid?
    assert_equal 1, Event.count
  end

  test "event should be created when overlapping records are allowed to be removed" do
    create(:event, court_ids: Court.pluck(:id))
    @events_form.submit(attributes_for(:event).merge(court_ids: Court.pluck(:id), allow_removal: true))
    assert @events_form.valid?
    assert_equal 1, Event.count
  end

  test "event should not be created when overlapping records are not allowed to be removed" do
    create(:event, court_ids: Court.pluck(:id))
    @events_form.submit(attributes_for(:event).merge(court_ids: Court.pluck(:id)))
    refute @events_form.valid?
    assert_equal 1, Event.count
  end

end