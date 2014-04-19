# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :allowed_action do
    name "My action"
    controller "my_controller"
    action ["action1", "action2"]

    factory :allowed_action_string do
      name "My action"
      controller "my_controller"
      action "action1, action2"
    end

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

    factory :user_edit do
      name "Edit my details"
      controller :users
      action [:edit, :update]
      user_specific true
    end

    factory :users_index do
      name "Add an opponent"
      controller :users
      action [:index]
    end

    factory :admin_index do
      name "Admin index"
      controller :admin
      action [:index]
    end

    factory :manage_members do
      name "Manage members"
      controller "admin/members"
      action [:index, :new, :create, :edit, :update, :delete]
      admin true
    end

    factory :manage_courts do
      name "Manage courts"
      controller "admin/courts"
      action [:index, :new, :create, :edit, :update, :delete]
      admin true
    end

    factory :manage_closures do
      name "Manage closures"
      controller "admin/closures"
      action [:index, :new, :create, :edit, :update, :delete]
      admin true
    end

    factory :manage_events do
      name "Manage events"
      controller "admin/events"
      action [:index, :new, :create, :edit, :update, :delete]
      admin true
    end

    factory :manage_settings do
      name "Manage settings"
      controller "admin/settings"
      action [:index, :update]
      admin true
    end

    factory :edit_all_bookings do
      name "Edit all bookings"
      controller "bookings"
      action [:edit, :update, :destroy]
    end

  end
end
