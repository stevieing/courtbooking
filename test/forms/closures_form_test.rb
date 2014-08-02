require "test_helper"

class ClosuresFormTest < ActiveSupport::TestCase

  def setup
    create_list(:court, 4)
    @closures_form = ClosuresForm.new
  end

  test "closure should be created with valid attributes" do
    @closures_form.submit(attributes_for(:closure).merge(court_ids: Court.pluck(:id)))
    assert @closures_form.valid?
    assert_equal 1, Closure.count
  end

  test "closure should not be created with invalid attributes" do
    @closures_form.submit(attributes_for(:closure))
    refute @closures_form.valid?
    assert_empty Closure.all
  end

  test "closure should be updated with valid attributes" do
    @closures_form = ClosuresForm.new(create(:closure))
    @closures_form.submit(attributes_for(:closure).merge(court_ids: Court.pluck(:id).drop(1)))
    assert @closures_form.valid?
    assert_equal 1, Closure.count
  end

  test "closure should be created when overlapping records are allowed to be removed" do
    create(:closure, court_ids: Court.pluck(:id))
    @closures_form.submit(attributes_for(:closure).merge(court_ids: Court.pluck(:id), allow_removal: true))
    assert @closures_form.valid?
    assert_equal 1, Closure.count
  end

  test "closure should not be created when overlapping records are not allowed to be removed" do
    create(:closure, court_ids: Court.pluck(:id))
    @closures_form.submit(attributes_for(:closure).merge(court_ids: Court.pluck(:id)))
    refute @closures_form.valid?
    assert_equal 1, Closure.count
  end

end