Courtbooking::Application.routes.draw do

  devise_for :users

  devise_scope :user do
    get "sign_in", to: "devise/sessions#new"
    delete "sign_out", to: "devise/sessions#destroy"
  end

  resources :bookings, except: [:new], constraints: { :id => /[0-9\.]+/ }
  resources :users, only: [:index, :edit, :update]

  namespace :admin do
    resources :settings, only: [:index, :edit, :update]
    resources :members, :courts, :events, :emails, :reports, :closures, :allowed_actions
  end

  root to: "courts#index"

  get 'admin' => "admin#index", as: :admin

  get '/courts(/:date)'=> "courts#index", as: :courts

  ##
  # TODO: This needs to be tested probably with constraints. Otherwise if bookings changes this could cause a
  # an error which will be difficult to find.
  #

  get 'bookings/new/:date_from/:time_from/:time_to/:court_id' => "bookings#new", as: :court_booking

end