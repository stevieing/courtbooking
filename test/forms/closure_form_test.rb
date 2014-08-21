require "test_helper"

class ClosureFormTest < ActiveSupport::TestCase

  def setup
    create_list(:court, 4)
    @closure_form = ClosureForm.new
  end

  test "closure should be created with valid attributes" do
    @closure_form.submit(attributes_for(:closure).merge(court_ids: Court.pluck(:id)))
    assert @closure_form.valid?
    assert_equal 1, Closure.count
  end

  test "closure should not be created with invalid attributes" do
    @closure_form.submit(attributes_for(:closure))
    refute @closure_form.valid?
    assert_empty Closure.all
  end

  test "closure should be updated with valid attributes" do
    @closure_form = ClosureForm.new(create(:closure))
    @closure_form.submit(attributes_for(:closure).merge(court_ids: Court.pluck(:id).drop(1)))
    assert @closure_form.valid?
    assert_equal 1, Closure.count
  end

  test "closure should be created when overlapping records are allowed to be removed" do
    create(:closure, court_ids: Court.pluck(:id))
    @closure_form.submit(attributes_for(:closure).merge(court_ids: Court.pluck(:id), allow_removal: true))
    assert @closure_form.valid?
    assert_equal 1, Closure.count
  end

  test "closure should not be created when overlapping records are not allowed to be removed" do
    create(:closure, court_ids: Court.pluck(:id))
    @closure_form.submit(attributes_for(:closure).merge(court_ids: Court.pluck(:id)))
    refute @closure_form.valid?
    assert_equal 1, Closure.count
  end

end