require 'spec_helper'

describe AdminMemberForm do
  it_behaves_like FormManager

  it_behaves_like "password processed" do
    let(:model) { :member }
  end

  let!(:allowed_actions)    { create_list(:allowed_action, 4)}
  let(:attributes_valid)    { attributes_for(:member).merge(allowed_action_ids: AllowedAction.pluck(:id))}
  let(:attributes_invalid)  { attributes_for(:member).merge(email: "")}

  subject           { AdminMemberForm.new}

  describe 'submit' do

    context 'valid' do
      before(:each) do
        subject.submit(attributes_valid)
      end

      it { expect(User.all).to have(1).item }
      it { expect(subject).to be_valid }
    end

    context 'invalid' do
      before(:each) do
        subject.submit(attributes_invalid)
      end

      it { expect(User.all).to have(0).items }
      it { expect(subject).to_not be_valid }
    end

  end

  describe '#include_action?' do

    let(:allowed_action) { build(:allowed_action, id: "999")}

    before(:each) do
      subject.submit(attributes_valid)
    end

    it { expect(subject.include_action?(allowed_actions.first)).to be_true}
    it { expect(subject.include_action?(allowed_action)).to be_false}

  end
end