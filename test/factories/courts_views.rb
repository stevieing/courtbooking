
FactoryGirl.define do

  factory :tab, class: Courts::Tab do

    date { Date.today+1 }
    user { create(:member) }
    slots { build(:slots)}

    initialize_with { new(date, user, slots)}
  end

  factory :calendar, class: Courts::Calendar do

    initialize_with { new(current_date: Date.today+1, no_of_days: 21)}
  end
end