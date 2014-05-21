#require "spec_helper"

describe BookingSlots::BookingsGrid do

  before(:each) do
    stub_settings
    create_standard_permissions
    Date.stub(:today).and_return(Date.parse("24 February 2014"))
  end

  let(:options)         { { slot_first: "07:00", slot_last: "17:00", slot_time: 30} }
  let(:court_slots)     { build(:court_slots, options: options) }
  let!(:courts)         { create_list(:court_with_defined_opening_and_peak_times, 4, opening_time_from: "07:00", opening_time_to: "17:00") }
  let!(:edit_bookings)  { create(:bookings_edit)}
  let!(:user)           { create(:member) }
  let!(:other_user)     { create(:member) }
  let!(:opponent)       { create(:member) }

  subject { BookingSlots::BookingsGrid.new(Date.today+1, user, court_slots) }

  it            { expect(subject.rows).to have(23).items }
  its(:heading) { should eq((Date.today+1).to_s(:uk))}

  describe "closures" do

    let!(:unavailable) {create(:closure, date_from: Date.today+1, court_ids: Court.pluck(:id), date_to: Date.today+2, time_from: "12:00", time_to: "15:00")}

    before(:each) do
      allow(Settings).to receive(:slots).and_return(CourtSlots.new(options))
    end

    subject { BookingSlots::BookingsGrid.new(Date.today+1, user, court_slots)}

    it { expect(subject.rows).to have(17).items}
    it { expect(subject.closure_message).to_not be_empty}

  end

  #       0       1           2           3           4         5
  # ----------------------------------------------------------------
  # 0           Court ?     Court ?     Court ?     Court ?
  # ----------------------------------------------------------------
  # 1   07:00                                                 07:00
  # ----------------------------------------------------------------
  # 2   07:30                                                 07:30
  # ----------------------------------------------------------------
  # 3   08:00   BOOKING1                                      08:00
  # ---------------------------------------------------------------- CURRENT TIME
  # 4   08:30                                                 08:30
  # ----------------------------------------------------------------
  # 5   09:00   EVENT1      EVENT1    BOOKING6                09:00
  # ----------------------------------------------------------------
  # 6   09:30   EVENT1      EVENT1                            09:30
  # ----------------------------------------------------------------
  # 7   10:00   EVENT1      EVENT1                            10:00
  # ----------------------------------------------------------------
  # 8   10:30                                                 10:30
  # ----------------------------------------------------------------
  # 9   11:00                             BOOKING2            11:00
  # ----------------------------------------------------------------
  # 10  11:30                             EVENT2    EVENT2    11:30
  # ----------------------------------------------------------------
  # 11  12:00                             EVENT2    EVENT2    12:00
  # ----------------------------------------------------------------
  # 12  12:30                                                 12:30
  # ----------------------------------------------------------------
  # 13  13:00                                                 13:00
  # ----------------------------------------------------------------
  # 14  13:30   CLOSURE1    CLOSURE1      CLOSURE1            13:30
  # ----------------------------------------------------------------
  # 15  14:00   CLOSURE1    CLOSURE1      CLOSURE1            14:00
  # ---------------------------------------------------------------- START OF PEAK HOURS
  # 16  14:30                                                 14:30
  # ----------------------------------------------------------------
  # 17  15:00               BOOKING3                          15:00
  # ----------------------------------------------------------------
  # 18  15:30                                       BOOKING4  15:30
  # ---------------------------------------------------------------- END OF PEAK HOURS
  # 19  16:00                                                 16:00
  # ----------------------------------------------------------------
  # 20  16:30                             BOOKING5            16:30
  # ----------------------------------------------------------------
  # 21  17:00                                       BOOKING7  17:00
  # ----------------------------------------------------------------
  # 22          Court ?     Court ?       Court ?     Court ?
  #

  describe "complete table" do

    let!(:booking1) { create(:booking, user: user, opponent: nil, date_from: Date.today+1, time_from: "08:00", time_to: "08:30", court_id: courts.first.id)}
    let!(:booking2) { create(:booking, user: user, opponent: nil, date_from: Date.today+1, time_from: "11:00", time_to: "11:30", court_id: courts[2].id)}
    let!(:booking3) { create(:booking, user: user, opponent: opponent, date_from: Date.today+1, time_from: "15:00", time_to: "15:30", court_id: courts[1].id)}
    let!(:booking4) { create(:booking, user: opponent, date_from: Date.today+1, time_from: "15:30", time_to: "16:00", court_id: courts[3].id)}
    let!(:booking5) { create(:booking, user: other_user, date_from: Date.today+1, time_from: "16:30", time_to: "17:00", court_id: courts[2].id)}

    let(:booking6)  { build(:booking, date_from: Date.today+1, time_from: "09:00", time_to: "09:30", court_id: courts[2].id) }
    let(:booking7)  { build(:booking, date_from: Date.today+1, time_from: "17:00", time_to: "17:30", court_id: courts.last.id) }

    let!(:event1)   { create(:event, description: "event1", date_from: Date.today+1, date_to: Date.today+2, time_from: "09:00", time_to: "10:30", court_ids: [courts.first.id,courts[1].id])}
    let!(:event2)   { create(:event, description: "event2", date_from: Date.today+1, date_to: Date.today+2, time_from: "11:30", time_to: "12:30", court_ids: [courts[2].id,courts.last.id])}

    let!(:closure1) { create(:closure, description: "closure1", date_from: Date.today+1, date_to: Date.today+2, time_from: "13:30", time_to: "14:30", court_ids: [courts.first.id, courts[1].id, courts[2].id])}

    before(:each) do
      allow(Time).to receive(:now).and_return(Time.parse("#{(Date.today+1).to_s(:uk)} 08:30"))
      allow(DateTime).to receive(:now).and_return(DateTime.parse("#{(Date.today+1).to_s(:uk)} 08:30"))
      user.permissions.create(allowed_action: edit_bookings)
    end

    subject { BookingSlots::BookingsGrid.new(Date.today+1, user, court_slots) }

    it { expect(subject.rows[1].klass).to eq("past")}

    it "everyting should be in its rightful place" do
      expect(cell(0,1)).to have_text("Court #{courts.first.number}")
      expect(cell(0,4)).to have_text("Court #{courts.last.number}")
      expect(cell(1,1)).to have_text(' ')
      expect(cell(1,1)).to have_text(' ')
      expect(cell(1,1)).to_not be_a_link
      expect(cell(3,1)).to have_text(booking1.players)
      expect(cell(3,1)).to_not be_a_link
      expect(cell(5,1)).to have_text(event1.description)
      expect(cell(5,1)).to_not be_a_link
      expect(cell(5,1)).to have_a_span_of(3)
      expect(cell(5,2)).to have_text(event1.description)
      expect(cell(5,2)).to have_a_span_of(3)
      expect(cell(5,3)).to have_text(booking6.link_text)
      expect(cell(5,3)).to be_a_link
      expect(cell(5,2)).to have_text(event1.description)
      expect(cell(6,1)).to be_blank
      expect(cell(6,2)).to be_blank
      expect(cell(7,1)).to be_blank
      expect(cell(7,2)).to be_blank
      expect(cell(8,1)).to be_active
      expect(cell(9,3)).to have_text(booking2.players)
      expect(cell(9,3)).to be_a_link
      expect(cell(10,3)).to have_text(event2.description)
      expect(cell(10,3)).to have_a_span_of(2)
      expect(cell(10,4)).to have_text(event2.description)
      expect(cell(10,4)).to have_a_span_of(2)
      expect(cell(11,3)).to be_blank
      expect(cell(11,3)).to be_blank
      expect(cell(14,1)).to have_text(closure1.description)
      expect(cell(14,2)).to have_text(closure1.description)
      expect(cell(14,3)).to have_text(closure1.description)
      expect(cell(15,1)).to be_blank
      expect(cell(15,2)).to be_blank
      expect(cell(15,3)).to be_blank
      expect(cell(17,2)).to have_text(booking3.players)
      expect(cell(17,2)).to be_a_link
      expect(cell(18,4)).to have_text(booking4.players)
      expect(cell(18,4)).not_to be_a_link
      expect(cell(20,3)).to have_text(booking5.players)
      expect(cell(20,3)).to_not be_a_link
      expect(cell(21,4)).to have_text(booking7.link_text)
      expect(cell(21,4)).to be_a_link
    end


  end

end