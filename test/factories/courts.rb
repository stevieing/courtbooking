# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :court do
    sequence(:number, 1) {|n| n}

    factory :court_with_opening_and_peak_times do
      after(:create) do |court|
        (0..6).each do |day|
          FactoryGirl.create(:opening_time, court: court, day: day)
          FactoryGirl.create(:peak_time, court: court, day: day) if day < 5
        end
      end
    end

    factory :court_with_defined_opening_and_peak_times do
      transient do
        opening_time_from "06:20"
        opening_time_to "22:20"
        peak_time_from "17:40"
        peak_time_to "20:20"
      end

      after(:create) do |court, evaluator|
        (0..6).each do |day|
          FactoryGirl.create(:opening_time, court: court, day: day, time_from: evaluator.opening_time_from, time_to: evaluator.opening_time_to)
          FactoryGirl.create(:peak_time, court: court, day: day, time_from: evaluator.peak_time_from, time_to: evaluator.peak_time_to) if day < 5
        end
      end
    end
  end
end
