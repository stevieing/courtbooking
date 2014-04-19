require "spec_helper"

describe Permissions::AdminPermission do

  before(:all) do
    load "#{Rails.root}/config/initializers/accepted_attributes.rb"
  end

  subject { Permissions.permission_for(build(:admin)) }

  it "allows anything" do
    should allow_action(:any, :thing)
    should allow_param(:booking, :time_and_place)
    should_not allow_param(:booking, :date_from_text)
    should allow_param(:booking, :opponent_id)
    should_not allow_param(:booking, :user_id)
    should allow_param(:booking, :date_from)
    should allow_param(:booking, :time_from)
    should allow_param(:booking, :time_to)
    should allow_param(:booking, :court_id)
    should allow_param(:booking, :opponent_name)
    should allow_param(:setting, :value)
    should allow_param(:member, :username)
    should allow_param(:member, :full_name)
    should allow_param(:member, :email)
    should allow_param(:member, :password)
    should allow_param(:member, :password_confirmation)
    should allow_param(:member, :allowed_action_ids => [])
    should allow_param(:court, :number)
    should allow_param(:court, :peak_times => [:day, :time_from, :time_to])
    should allow_param(:court, :opening_times => [:day, :time_from, :time_to])
    should allow_param(:closure, :description)
    should allow_param(:closure, :date_from)
    should allow_param(:closure, :date_to)
    should allow_param(:closure, :time_from)
    should allow_param(:closure, :time_to)
    should allow_param(:closure, :court_ids => [])
    should allow_param(:closure, :allow_removal)
    should allow_param(:event, :description)
    should allow_param(:event, :date_from)
    should allow_param(:event, :date_to)
    should allow_param(:event, :time_from)
    should allow_param(:event, :time_to)
    should allow_param(:event, :court_ids => [])
    should allow_param(:event, :allow_removal)
    should allow_param(:allowed_action, :name)
    should allow_param(:allowed_action, :controller)
    should allow_param(:allowed_action, :action_text)

  end

end