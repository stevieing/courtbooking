require 'spec_helper'

describe BookingSlots::Calendar do

  let(:date_from)   { Date.parse("Sun 22 March")}

  before(:each) do
    allow(Date).to receive(:today).and_return(Date.parse("Sat 30 March"))
  end

  let(:attributes) { { date_from: date_from, current_date: Date.today, no_of_days: 21, split: 7 } }
  subject { BookingSlots::Calendar.new(attributes)}

  it { expect(subject.rows.first).to be_a_heading }
  it { expect(subject.rows).to have(4).items }
  it { expect(subject.dates).to have(21).items}
  it { expect(cell(1,0)).to have_text(date_from.day_of_month)}
  it { expect(cell(1,0)).to be_a_link}
  it { expect(cell(2,1)).to have_text(Date.today.day_of_month)}
  it { expect(cell(2,1)).to_not be_a_link}

  its(:heading) { should eq(date_from.calendar_header(subject.dates.last))}

  describe "different number of days" do
    let(:new_attributes) { attributes.merge(no_of_days: 20)}
    subject { BookingSlots::Calendar.new(new_attributes)}

    it { expect(subject.rows).to have(4).items }
    it { expect(subject.dates).to have(20).items }
    it { expect(subject.rows[3]).to have(6).items }
  end


end