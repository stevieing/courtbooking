require 'spec_helper'

describe BookingSlots::Wrapper do

	class TestWrapper

		include BookingSlots::Wrapper

		def initialize(*attributes)
			@attributes = attributes
		end

		def wrapped_attributes
			@attributes
		end

    def capped_attributes
      @attributes
    end

		def the_wrap
			["l","h"]
		end

    def the_cap
      "capped"
    end

		wrap :wrapped_attributes, :the_wrap
    cap :capped_attributes, :the_cap

	end

	subject { TestWrapper.new(1,2,3,4,5)}

	it { expect(subject.wrapped_attributes).to eq([["l","h"],1,2,3,4,5,["l","h"]])}
  it { expect(subject.capped_attributes).to eq(["capped",1,2,3,4,5])}


end