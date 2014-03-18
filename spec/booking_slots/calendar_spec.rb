require 'spec_helper'

describe BookingSlots::Calendar do

  let(:date_from)   { Date.parse("Sun 22 March")}

  before(:each) do
    allow(Date).to receive(:today).and_return(Date.parse("Sat 30 March"))
  end

  subject { BookingSlots::Calendar.new(date_from, Date.today, 21, 7)}

  it { expect(subject.rows.first).to be_a_heading }
  it { expect(subject.rows).to have(4).items }
  it { expect(subject.dates).to have(21).items}
  it { expect(cell(1,0)).to have_text(date_from.day_of_month)}
  it { expect(cell(1,0)).to be_a_link}
  it { expect(cell(2,1)).to have_text(Date.today.day_of_month)}
  it { expect(cell(2,1)).to_not be_a_link}

  its(:heading) { should eq(date_from.calendar_header(subject.dates.last))}


end