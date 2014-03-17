require 'spec_helper'

describe ParametersProcessor do

  class PasswordChecker
    include ParametersProcessor
  end

  subject { PasswordChecker.new }

  context 'all ok' do

    let(:parameters) { { :other_attribute => "dummy", :password => "password", :password_confirmation => "password" } }

    it { expect(subject.process_parameters(parameters)).to eq(parameters) }

  end

  context 'password blank' do

    let(:parameters) { { :other_attribute => "dummy", :password => "", :password_confirmation => "password" } }

    it { expect(subject.process_parameters(parameters)).to eq(parameters) }
  end

  context 'password confirmation blank' do

    let(:parameters) { { :other_attribute => "dummy", :password => "password", :password_confirmation => "" } }

    it { expect(subject.process_parameters(parameters)).to eq(parameters) }
  end

  context 'password and password confirmation blank' do

    let(:parameters) { { :other_attribute => "dummy", :password => "", :password_confirmation => "" } }

    it { expect(subject.process_parameters(parameters)).to eq({ :other_attribute => "dummy" }) }
  end

end