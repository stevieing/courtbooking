class Occurrence < ActiveRecord::Base
  belongs_to :court
  belongs_to :activity
end