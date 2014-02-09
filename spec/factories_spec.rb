# spec/factories_spec.rb
require 'spec_helper'

describe FactoryGirl do
  FactoryGirl.factories.map(&:name).each do |factory_name|
    describe "The #{factory_name} factory" do
      it 'is valid' do
        build(factory_name).should be_valid
      end
    end
  end
end