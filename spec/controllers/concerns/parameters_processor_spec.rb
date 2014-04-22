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

    let(:parameters) { { other_attribute: "dummy", password: "password", password_confirmation: "password" } }

    subject { PasswordChecker.new }

    context 'all ok' do

      it { expect(subject.process_password(parameters)).to eq(parameters) }

    end

    context 'password blank' do

      let(:parameters_no_password) { parameters.merge(password: "") }

      it { expect(subject.process_password(parameters_no_password)).to eq(parameters_no_password) }
    end

    context 'password confirmation blank' do

      let(:parameters_no_confirmation) { parameters.merge(password_confirmation: "") }

      it { expect(subject.process_password(parameters_no_confirmation)).to eq(parameters_no_confirmation) }
    end

    context 'password and password confirmation blank' do

      let(:parameters_attribute_only) { parameters.merge(password: "", password_confirmation: "")}

      it { expect(subject.process_password(parameters_attribute_only)).to eq({ :other_attribute => "dummy" }) }
    end

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