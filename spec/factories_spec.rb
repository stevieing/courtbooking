# spec/factories_spec.rb
require 'spec_helper'

describe FactoryGirl do
  FactoryGirl.factories.map(&:name).each do |factory_name|
    describe "The #{factory_name} factory" do
      if factory_name == :booking
        before(:each) do
          create_standard_settings
        end
      end
      it 'is valid' do
        build(factory_name).should be_valid
      end
    end
  end
end