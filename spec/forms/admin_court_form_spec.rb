require 'spec_helper'

describe AdminCourtForm do

  it_behaves_like FormManager

  let(:court)                          { attributes_for(:court)}
  let(:opening_time)                   { attributes_for(:opening_time)}
  let(:bad_opening_time)               { opening_time.merge(:day => "")}
  let(:peak_time)                      { attributes_for(:peak_time)}
  let(:bad_peak_time)                  { peak_time.merge(:day => "")}
  let(:attributes_valid)               { court.merge("peak_times" => { "1" => opening_time}).merge("opening_times" => { "1" => peak_time})}
  let(:attributes_bad_court)           { attributes_valid.merge(:number => nil)}
  let(:attributes_bad_opening_time)    { court.merge("peak_times" => { "1" => bad_opening_time}).merge("opening_times" => { "1" => peak_time})}
  let(:attributes_bad_peak_time)       { court.merge("peak_times" => { "1" => opening_time}).merge("opening_times" => { "1" => bad_peak_time})}

  subject { AdminCourtForm.new}

  describe 'number' do

    it { expect(subject.number).to_not be_nil}
    it { expect(subject.number).to be_instance_of(Fixnum)}
  end

  describe 'submit' do

    context 'valid' do
      before(:each) do
        subject.submit(attributes_valid)
      end

      it { expect(Court.all).to have(1).item }
      it { expect(OpeningTime.all).to have(1).item }
      it { expect(PeakTime.all).to have(1).item }
      it { expect(subject.opening_times).to have(1).item}
      it { expect(subject.peak_times).to have(1).item}
      it { expect(subject).to be_valid }
    end

    context 'invalid court' do
      before(:each) do
        subject.submit(attributes_bad_court)
      end

      it { expect(Court.all).to have(0).items }
      it { expect(subject).to_not be_valid }
    end

    context 'invalid opening time' do
      before(:each) do
        subject.submit(attributes_bad_opening_time)
      end

      it { expect(Court.all).to have(0).items }
      it { expect(OpeningTime.all).to have(0).item }
      it { expect(subject).to_not be_valid }
    end

    context 'invalid peak time' do
      before(:each) do
        subject.submit(attributes_bad_peak_time)
      end

      it { expect(Court.all).to have(0).items }
      it { expect(PeakTime.all).to have(0).item }
      it { expect(subject).to_not be_valid }
    end
  end

end