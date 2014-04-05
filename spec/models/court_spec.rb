require 'spec_helper'

describe Court do

  it { should have_many(:opening_times)}
  it { should have_many(:peak_times)}
  it { should have_many(:bookings)}
  it { should have_many(:closures).through(:occurrences)}
  it { should have_many(:events).through(:occurrences)}
  it { should validate_presence_of(:number) }
  it { should validate_uniqueness_of(:number) }

  describe "peak_times" do

    let!(:courts) { create_list(:court_with_opening_and_peak_times, 4)}

    it { courts.first.peak_time?(1,"09:40").should be_false}
    it { courts.first.peak_time?(1,"19:00").should be_true}
    it { courts.first.peak_time?(2,"19:00").should be_true}
    it { Court.peak_time?(courts.first.id, 1,"19:00").should be_true}
    it { Court.peak_time?(courts.first.id, 1,"09:40").should be_false}
  end

  describe "next court number" do

    it { expect(Court.next_court_number).to eq(1)}

    context "with multiple records" do

      let!(:courts) { create_list(:court,3)}

      it {expect(Court.next_court_number).to eq(Court.last.number+1)}
    end
  end

  describe "closures" do

    let(:date)      { Date.today}
    let!(:courts)   { create_list(:court, 4)}
    let(:court_ids) { Court.pluck(:id)}

    context "for all courts" do

      let!(:closure) { create(:closure, date_from: date, court_ids: court_ids)}

      it { expect(Court.closures_for_all_courts(date)).to include(closure)}

    end

    context "for all courts on multiple days" do

      let(:date_to)   {Date.today+5}
      let!(:closure) { create(:closure, date_from: date, date_to: date_to, court_ids: court_ids)}

      it { expect(Court.closures_for_all_courts(date)).to include(closure)}
      it { expect(Court.closures_for_all_courts(date_to)).to include(closure)}
      it { expect(Court.closures_for_all_courts(date_to+1)).to be_empty}
    end

    context "for some of the courts" do
      let!(:closure) { create(:closure, date_from: date, court_ids: [court_ids.first,court_ids.last])}

      it { expect(Court.closures_for_all_courts(date)).to be_empty }
    end


  end

  describe '#by_day' do

    context 'no opening times' do
      let!(:court) { create(:court)}

      subject { Court.by_day(Date.today)}

      it { expect(subject).to be_empty}

    end

    context 'opening times' do
      let!(:court) { create(:court_with_defined_opening_and_peak_times)}

      subject { Court.by_day(Date.today)}

      it { expect(subject.first.opening_times).to_not be_empty}
    end
  end


end