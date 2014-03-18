require 'spec_helper'

describe AllowedAction, :focus => true do

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

end
