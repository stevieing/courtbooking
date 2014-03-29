require 'spec_helper'

describe AdminClosureForm do
  it_behaves_like FormManager
  it_behaves_like OverlappingRecordsManager

  let!(:courts)             { create_list(:court, 4)}
  let(:attributes_valid)    { attributes_for(:closure).merge(:court_ids => Court.pluck(:id))}
  let(:attributes_invalid)  { attributes_for(:closure)}

  subject           { AdminClosureForm.new}

  describe 'submit' do

    context 'valid' do
      before(:each) do
        subject.submit(attributes_valid)
      end

      it { expect(Closure.all).to have(1).item }
      it { expect(subject).to be_valid }
    end

    context 'invalid' do
      before(:each) do
        subject.submit(attributes_invalid)
      end

      it { expect(Closure.all).to have(0).items }
      it { expect(subject).to_not be_valid }
    end
  end

  it_behaves_like "Removes overlapping records" do
    let(:attributes) { attributes_valid }
  end

   it_behaves_like "Verifies removal of overlapping records" do
    let(:attributes) { attributes_valid }
  end
end