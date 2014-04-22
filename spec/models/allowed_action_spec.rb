require 'spec_helper'

describe AllowedAction do

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:controller) }
  it { should validate_presence_of(:action)}
  it { should have_db_column(:user_specific).of_type(:boolean).with_options(default: false)}
  it { should have_db_column(:admin).of_type(:boolean).with_options(default: false)}

  describe '#action_text' do
    subject { create(:allowed_action, action_text: "a,b,c,d,e")}

    it { should be_valid }
    it { expect(subject.action).to eq(["a","b","c","d","e"])}
    it { expect(subject.action_text).to eq("a,b,c,d,e")}

  end

  describe '#user_specific?' do
    subject { create(:allowed_action, user_specific: true)}

    its(:user_specific?) { should be_true }
  end

  describe '#admin?' do
    subject { create(:allowed_action, admin: true)}

    its(:admin?) { should be_true }
  end

  describe '#sanitized_controller' do

    context 'singular' do
      subject { create(:allowed_action, controller: :bollocks)}

      its(:sanitized_controller) { should eq(:bollock)}
    end

    context 'multiple' do
      subject { create(:allowed_action, controller: "dodgy/numbers")}

      its(:sanitized_controller) { should eq(:number)}
    end

  end

  describe '#non_user_specific?' do

    context 'true' do
      subject { build(:allowed_action, user_specific: true)}

      its(:non_user_specific?) { should be_false}
    end

    context 'false' do
      subject { build(:allowed_action, user_specific: false)}

      its(:non_user_specific?) { should be_true}
    end

  end


end
