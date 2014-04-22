require 'spec_helper'

describe Guest do

  describe '#all_bookings' do

    subject { Guest.new }

    its(:all_bookings) { should be_kind_of(ActiveRecord::Relation)}
    its(:all_bookings) { should be_empty }
  end

  describe '#permissions' do

    subject { Guest.new.permissions }

    it { expect(subject).to have(3).items}
    it { expect(subject.all? { |permission| permission.instance_of?(AllowedAction)}).to be_true}

  end

  it_behaves_like "Current permissions"

end