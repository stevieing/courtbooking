# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :allowed_action do
    name "MyString"
    controller "MyString"
    action ["MyString"]
    
    factory :bookings_index do
      name "View all bookings"
      controller :bookings
      action [:index]
    end
    
    factory :bookings_new do
      name "Create a new booking"
      controller :bookings
      action [:new, :create]
    end
    
    factory :bookings_show do
      name "View a booking"
      controller :bookings
      action [:show]
    end
    
    factory :bookings_destroy do
      name "Delete a booking"
      controller :bookings
      action [:destroy]
      user_specific true
    end
    
    factory :bookings_edit do
      name "Edit a booking"
      controller :bookings
      action [:edit, :update]
      user_specific true
    end
    
  end
end
