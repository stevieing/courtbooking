require 'spec_helper'

describe User::Admin do

  subject { build(:admin)}

  it_behaves_like "an STI class"

  it_behaves_like "Current permissions"

  describe '#all_bookings' do

    subject { create(:admin)}

    before(:each) do
      stub_settings
    end

    let!(:booking1) { create(:booking, date_from: Date.today+1)}
    let!(:booking2) { create(:booking, date_from: Date.today+2)}
    let!(:booking3) { create(:booking, date_from: Date.today+3, user: subject)}

    it { expect(subject.all_bookings).to have(3).items}
  end

end