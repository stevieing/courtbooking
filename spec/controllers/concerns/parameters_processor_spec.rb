require 'spec_helper'

describe ParametersProcessor do

  class PasswordChecker
    include ParametersProcessor
  end

  class AllowRemovalChecker
    include ParametersProcessor
    attr_accessor :allow_removal, :attr_a, :attr_b
  end

  describe '#process_password' do

    subject { PasswordChecker.new }

    context 'all ok' do

      let(:parameters) { { :other_attribute => "dummy", :password => "password", :password_confirmation => "password" } }

      it { expect(subject.process_password(parameters)).to eq(parameters) }

    end

    context 'password blank' do

      let(:parameters) { { :other_attribute => "dummy", :password => "", :password_confirmation => "password" } }

      it { expect(subject.process_password(parameters)).to eq(parameters) }
    end

    context 'password confirmation blank' do

      let(:parameters) { { :other_attribute => "dummy", :password => "password", :password_confirmation => "" } }

      it { expect(subject.process_password(parameters)).to eq(parameters) }
    end

    context 'password and password confirmation blank' do

      let(:parameters) { { :other_attribute => "dummy", :password => "", :password_confirmation => "" } }

      it { expect(subject.process_password(parameters)).to eq({ :other_attribute => "dummy" }) }
    end

  end

  describe '#permit_parameters' do
    let(:parameters) { ActionController::Parameters.new(attr_a: "a",attr_b: "b", attr_c: "c")}
    subject { PasswordChecker.new.permit_parameters(parameters, [:attr_a, :attr_b, :attr_c])}

    it { expect(subject).to be_permitted }

  end

  describe '#process_allow_removal' do

    subject           { AllowRemovalChecker.new }

    context 'true' do
      let(:parameters)  { { attr_a: "a", attr_b: "b", allow_removal: "1" }}
      it { expect(subject.process_allow_removal(parameters)).to eq({ attr_a: "a", attr_b: "b"})}
      it { expect{subject.process_allow_removal(parameters)}.to change{subject.allow_removal}.from(nil).to(true)}
    end

    context 'false' do
      let(:parameters)  { { attr_a: "a", attr_b: "b", allow_removal: "0" }}
      it { expect(subject.process_allow_removal(parameters)).to eq({ attr_a: "a", attr_b: "b"})}
      it { expect{subject.process_allow_removal(parameters)}.to change{subject.allow_removal}.from(nil).to(false)}
    end

  end

end