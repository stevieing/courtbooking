require 'test_helper'
require 'rails/performance_test_help'

class CourtsPageTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { runs: 5, metrics: [:wall_time, :memory],
  #                          output: 'tmp/performance', formats: [:flat] }

  def setup
    stub_settings
    create_list(:court_with_opening_and_peak_times, 4)
    AppSettings.const.stubs(:slots).returns(Slots::Base.new(options.merge(courts: Court.all)))
  end

  test "courtspage" do
    get '/courts'
  end

  def teardown
    Court.all.each do |court|
      court.destroy
    end
  end

end
