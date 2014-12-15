
FactoryGirl.define do

  factory :courts_grid, class: Courts::Grid do

    date { Date.today+1 }
    user { create(:member) }
    grid { build(:grid)}

    initialize_with { new(date, user, grid)}
  end

  factory :calendar, class: Courts::Calendar do

    initialize_with { new(current_date: Date.today+1, no_of_days: 21)}
  end
end