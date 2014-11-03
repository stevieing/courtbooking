require "test_helper"

class CourtFormTest < ActiveSupport::TestCase

  def setup
    @court_form = CourtForm.new
  end

  test "court number should be valid" do
    refute_nil @court_form.number
  end

  test "court should be created with valid attributes" do
    @court_form.submit(attributes_for(:court).merge({opening_times: {"1" => attributes_for(:opening_time)},
      peak_times: {"1" => attributes_for(:peak_time)}}.with_indifferent_access))
    assert @court_form.valid?
    assert_equal 1, Court.count
    assert_equal 1, OpeningTime.count
    assert_equal 1, PeakTime.count
  end

  test "court should not be created with invalid attributes" do
    @court_form.submit(number: nil)
    refute @court_form.valid?
    assert_empty Court.all
  end

  test "court should not be created with invalid opening time" do
    @court_form.submit(attributes_for(:court).merge({opening_times: {"1" => attributes_for(:opening_time)
      .merge(day: "")}}.with_indifferent_access))
    refute @court_form.valid?
    assert_empty Court.all
    assert_empty OpeningTime.all
  end

  test "court should not be created with invalid peak time" do
    @court_form.submit(attributes_for(:court).merge({peak_times: {"1" => attributes_for(:peak_time)
      .merge(day: "")}}.with_indifferent_access))
    refute @court_form.valid?
    assert_empty Court.all
    assert_empty PeakTime.all
  end

  test "court should be updated with valid attributes" do
    @court_form = CourtForm.new(create(:court, opening_times: [create(:opening_time)]))
    @court_form.submit(attributes_for(:court).merge({opening_times: {"1" => attributes_for(:opening_time)
      .merge(time_from: "05:00")}}.with_indifferent_access))
    assert @court_form.valid?
    assert_equal 1, Court.count
    assert_equal "05:00", OpeningTime.first.time_from
  end

end