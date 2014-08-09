# This is dummy model free of all constraints for testing forms and things.
class TestModel < ActiveRecord::Base

  validates_presence_of :attr_a, :attr_b, :attr_c
  validates_numericality_of :attr_c
end
