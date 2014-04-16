require 'spec_helper'

describe Guest, focus: true  do

  describe '#all_bookings' do

    subject { Guest.new }

    its(:all_bookings) { should be_kind_of(ActiveRecord::Relation)}
    its(:all_bookings) { should be_empty }
  end
end