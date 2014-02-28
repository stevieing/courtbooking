require 'spec_helper'

describe BookingSlots::CurrentRecord do
  
  describe "#new" do

  	context "no block" do
  		subject { BookingSlots::CurrentRecord.new }

	  	its(:text) 	{ should be_nil }
	  	its(:link)	{ should be_nil }
	  	its(:span)	{ should eq(1)  }
	  	its(:klass)	{ should be_nil }
  	end

  	context "with a block" do
  		subject { BookingSlots::CurrentRecord.new do |rec|
  			rec.text 	= "some text"
  			rec.link 	= "/a/link"
  			rec.span 	= 10
  			rec.klass = "sillyclass"
  		end
  		}

			its(:text) 	{ should eq('some text') }
	  	its(:link)	{ should eq("/a/link") }
	  	its(:span)	{ should eq(10)  }
	  	its(:klass)	{ should eq("sillyclass") }
  	end

  end

  describe '#create' do

  	class TestRecord

  		attr_reader :text, :link, :span, :klass
  		def initialize(text, link, span, klass)
  			@text, @link, @span, @klass = text, link, span, klass
  		end
  	end

  	context 'valid object' do
  		let(:test_object) { TestRecord.new("some text", "/a/link", 10, "sillyclass")}

      before(:each) do
        @record = BookingSlots::CurrentRecord.create(test_object) do |c|
            c.text  = test_object.text
            c.link  = test_object.link
            c.span  = test_object.span
            c.klass = test_object.klass
        end
      end

      it { expect(@record).to be_instance_of(BookingSlots::CurrentRecord) }
      it { expect(@record.text).to eq("some text") }
      it { expect(@record.link).to eq("/a/link") }
      it { expect(@record.span).to eq(10) }
      it { expect(@record.klass).to eq("sillyclass") }

  	end

    context 'nil' do
      let(:test_object) { nil }
      before(:each) do
        @record = BookingSlots::CurrentRecord.create(test_object) do |c|
            c.text  = test_object.text
            c.link  = test_object.link
            c.span  = test_object.span
            c.klass = test_object.klass
        end
      end

      it { expect(@record).to be_nil }
    end
    
  end
end