require "spec_helper"

describe BookingSlots::Unavailable do

	let!(:courts) { create_list(:court, 4)}

	let!(:closure1) 			{ create(:closure, court_ids: Court.pluck(:id), date_from: Date.today+1, date_to: Date.today+2) }
	let!(:closure2) 			{ create(:closure, court_ids: Court.pluck(:id), date_from: Date.today+1, date_to: Date.today+3) }
	let!(:closure3) 			{ create(:closure, court_ids: Court.pluck(:id), date_from: Date.today+3, date_to: Date.today+5) }
	let(:properties)			{ build(:properties, date: Date.today+1)}
	let(:unavailable)			{ BookingSlots::Unavailable.new(properties) }

	it { expect(unavailable).to have(2).items }
  it { expect(unavailable.message).to eq("#{closure1.message}#{closure2.message}")}

end