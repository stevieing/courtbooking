require 'spec_helper'

describe User::Member do

  it_behaves_like "an STI class" do
    subject { build(:member)}
  end

  describe '#all_bookings' do

    subject { create(:member)}

    before(:each) do
      stub_settings
      add_standard_permissions subject
    end

    let!(:booking1) { create(:booking, date_from: Date.today+1)}
    let!(:booking2) { create(:booking, date_from: Date.today+2)}
    let!(:booking3) { create(:booking, date_from: Date.today+3, user: subject)}

    context 'no permission' do

      it { expect(subject.all_bookings).to have(1).item}
    end

    context 'permission' do

      before(:each) do
        add_admin_permissions subject
      end

      it { expect(subject.all_bookings).to have(3).items}
    end
  end

  describe '#permit_new!' do

    it { expect(subject).to respond_to(:permit_new!)}
  end

end