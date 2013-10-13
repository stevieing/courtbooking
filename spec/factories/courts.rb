# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :court do
    sequence(:number, 1) {|n| n}
    
    factory :court_with_opening_and_peak_times do
      after(:create) do |court|
        (0..6).each do |day|
          FactoryGirl.create(:opening_time, court: court, day: day)
          FactoryGirl.create(:peak_time, court: court, day: day) if day > 0 && day < 6
        end
      end
    end
    
    factory :court_with_split_opening_times do
       after(:create) do |court|
          (0..6).each do |day|
            FactoryGirl.create(:opening_time, from: "06:20", to: "08:20", court: court, day: day)
            FactoryGirl.create(:opening_time, from: "17:40", to: "22:00", court: court, day: day)
          end
        end
    end
  end
end
