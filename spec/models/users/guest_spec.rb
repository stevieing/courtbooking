require 'spec_helper'

describe Guest do

  describe '#all_bookings' do

    subject { Guest.new }

    its(:all_bookings) { should be_kind_of(ActiveRecord::Relation)}
    its(:all_bookings) { should be_empty }
  end

  it_behaves_like "Current permissions"

end