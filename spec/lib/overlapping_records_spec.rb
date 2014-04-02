require 'spec_helper'

describe OverlappingRecords do

  describe "parameters" do

    context 'booking' do
      let(:booking) { build(:booking)}

      subject { OverlappingRecords.new(booking) }

      it { expect(subject.parameters.date_from).to eq(booking.date_from)}
      it { expect(subject.parameters.date_to).to eq(booking.date_from)}
      it { expect(subject.parameters.time_from).to eq(booking.time_from)}
      it { expect(subject.parameters.time_to).to eq(booking.time_to)}
      it { expect(subject.parameters.court_ids).to eq([booking.court_id])}

    end

    context 'closure' do
      let(:closure) { build(:closure)}

      subject { OverlappingRecords.new(closure) }

      it { expect(subject.parameters.date_from).to eq(closure.date_from)}
      it { expect(subject.parameters.date_to).to eq(closure.date_to)}
      it { expect(subject.parameters.time_from).to eq(closure.time_from)}
      it { expect(subject.parameters.time_to).to eq(closure.time_to)}
      it { expect(subject.parameters.court_ids).to eq(closure.court_ids)}

    end

    context 'event' do
      let(:event) { build(:event)}

      subject { OverlappingRecords.new(event) }

      it { expect(subject.parameters.date_from).to eq(event.date_from)}
      it { expect(subject.parameters.date_to).to eq(event.date_from)}
      it { expect(subject.parameters.time_from).to eq(event.time_from)}
      it { expect(subject.parameters.time_to).to eq(event.time_to)}
      it { expect(subject.parameters.court_ids).to eq(event.court_ids)}

    end

  end

  describe 'valid' do

    context 'date_from' do
      it { expect(OverlappingRecords.new(build(:booking, date_from: nil))).not_to be_valid }
      it { expect(OverlappingRecords.new(build(:booking, date_from: ""))).not_to be_valid }
    end

    context 'time_from' do
      it { expect(OverlappingRecords.new(build(:booking, time_from: nil))).not_to be_valid }
      it { expect(OverlappingRecords.new(build(:booking, time_from: ""))).not_to be_valid }
    end

    context 'time_to' do
      it { expect(OverlappingRecords.new(build(:booking, time_to: nil))).not_to be_valid }
      it { expect(OverlappingRecords.new(build(:booking, time_to: ""))).not_to be_valid }
    end

    context 'court_ids' do
      it { expect(OverlappingRecords.new(build(:booking, court_id: nil))).not_to be_valid }
      it { expect(OverlappingRecords.new(build(:booking, court_id: ""))).not_to be_valid }
    end
  end

  describe 'records' do

    context 'valid' do
      subject { OverlappingRecords.new(build(:booking)) }

      it { expect(subject).to be_empty }
      it { expect(subject).to have(0).items }
    end

    context 'invalid' do
      subject { OverlappingRecords.new(build(:booking, date_from: nil)) }

      it { expect(subject).to be_empty }
      it { expect(subject).to have(0).items }
    end

  end

  describe 'overlapping' do

     before(:each) do
      stub_dates("24 Mar 2014", "19:00")
      stub_settings
    end

    let!(:courts)     { create_list(:court_with_opening_and_peak_times, 4)}
    let!(:users)      { create_list(:user, 4)}

    context 'bookings' do

      let!(:closure)  { create(:closure, date_from: Date.today+10, date_to: Date.today+15, time_from: "12:00", time_to: "19:00", courts: [courts.first, courts[1], courts[2]])}

      let!(:booking1) { create(:booking, date_from: Date.today+1, time_from: "19:00", time_to: "19:40", court: courts.first, user: users.first)}
      let!(:booking2) { create(:booking, date_from: Date.today+1, time_from: "19:00" , time_to: "19:40", court: courts.last, user: users[1])}

      it { expect(OverlappingRecords.new(build(:booking, date_from: Date.today+1, time_from: "18:20", time_to: "19:00", court: courts.first, user: users.first))).to be_empty}
      it { expect(OverlappingRecords.new(build(:booking, date_from: Date.today+1, time_from: "19:40", time_to: "20:20", court: courts.first, user: users.first))).to be_empty}
      it { expect(OverlappingRecords.new(build(:booking, date_from: Date.today+2, time_from: "19:00", time_to: "19:40", court: courts.first, user: users.first))).to be_empty}
      it { expect(OverlappingRecords.new(build(:booking, date_from: Date.today+2, time_from: "19:00", time_to: "19:40", court: courts.last, user: users.first))).to be_empty}
      it { expect(OverlappingRecords.new(build(:booking, date_from: Date.today+1, time_from: "19:00", time_to: "19:40", court: courts.first, user: users.first))).to_not be_empty}
      it { expect(OverlappingRecords.new(build(:booking, date_from: Date.today+1, time_from: "18:20", time_to: "19:01", court: courts.first, user: users.first))).to_not be_empty}
      it { expect(OverlappingRecords.new(build(:booking, date_from: Date.today+1, time_from: "19:39", time_to: "20:20", court: courts.first, user: users.first))).to_not be_empty}
      it { expect(OverlappingRecords.new(build(:booking, date_from: Date.today+1, time_from: "19:00", time_to: "19:40", court: courts.last, user: users.first))).to_not be_empty}

    end

    context 'activities' do
      let!(:booking1) { create(:booking, date_from: Date.today+1, time_from: "07:00", time_to: "07:40", court: courts.first, user: users.first)}
      let!(:closure)  { create(:closure, date_from: Date.today+1, date_to: Date.today+5, time_from: "12:00", time_to: "19:00", courts: [courts.first, courts[1], courts[2]])}
      let!(:event)    { create(:event, date_from: Date.today+2, time_from: "19:00", time_to: "20:20", courts: [courts.first])}

      it { expect(OverlappingRecords.new(build(:closure, date_from: Date.today+1, date_to: Date.today+2, time_from: "09:00", time_to: "12:00", courts: [courts.first]))).to be_empty}
      it { expect(OverlappingRecords.new(build(:closure, date_from: Date.today+1, date_to: Date.today+2, time_from: "15:00", time_to: "21:00", courts: [courts.last]))).to be_empty}
      it { expect(OverlappingRecords.new(build(:closure, date_from: Date.today+6, date_to: Date.today+10, time_from: "12:00", time_to: "19:00", courts: [courts.first, courts[1], courts[2]]))).to be_empty}
      it { expect(OverlappingRecords.new(build(:event, date_from: Date.today+1, time_from: "19:40", time_to: "20:20", courts: [courts.first, courts[1], courts[2]]))).to be_empty}
      it { expect(OverlappingRecords.new(build(:closure, date_from: Date.today+1, date_to: Date.today+2, time_from: "09:00", time_to: "17:00", courts: [courts.first]))).to_not be_empty}
      it { expect(OverlappingRecords.new(build(:closure, date_from: Date.today+1, date_to: Date.today+2, time_from: "13:00", time_to: "18:00", courts: [courts.first, courts.last]))).to_not be_empty}
      it { expect(OverlappingRecords.new(build(:event, date_from: Date.today+1, time_from: "13:00", time_to: "14:00", courts: [courts.first]))).to_not be_empty}
      it { expect(OverlappingRecords.new(build(:closure, date_from: Date.today+5, date_to: Date.today+7, time_from: "18:59", time_to: "21:00", courts: [courts.first, courts.last]))).to_not be_empty}

      it { expect(OverlappingRecords.new(closure)).to be_empty}

    end

    # this is an edge case which needs some sorting
    context 'specific bug' do

      let!(:booking1) { create(:booking, date_from: Date.today+1, time_from: "07:40", time_to: "08:20", court: courts.first, user: users.first)}

      it { expect(OverlappingRecords.new(build(:closure, date_from: Date.today+1, date_to: Date.today+1, time_from: "06:00", time_to: "09:00", courts: [courts.first]))).to_not be_empty}
    end

    context 'distinct' do
      let!(:closure)  { create(:closure, date_from: Date.today+1, date_to: Date.today+5, time_from: "12:00", time_to: "19:00", courts: [courts.first, courts[1], courts[2]])}

      it { expect(OverlappingRecords.new(build(:closure, date_from: Date.today+1, date_to: Date.today+2, time_from: "13:00", time_to: "18:00", courts: [courts.first, courts.last])).records).to have(1).item}
    end

  end

end