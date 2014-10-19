class FakeSetting < ActiveRecord::Base

  include AppSettings::ModelTrigger

end