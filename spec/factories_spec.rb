# spec/factories_spec.rb
require 'spec_helper'

describe FactoryGirl do
  FactoryGirl.factories.map(&:name).each do |factory_name|
    describe "The #{factory_name} factory" do
      if factory_name == :booking
        before(:each) do
          create_settings :days_bookings_can_be_made_in_advance, :max_peak_hours_bookings, :peak_hours_start_time, :peak_hours_finish_time 
        end
      end
      it 'is valid' do
        build(factory_name).should be_valid
      end
    end
  end
end