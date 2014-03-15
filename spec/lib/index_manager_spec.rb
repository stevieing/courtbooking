require 'spec_helper'

describe IndexManager do
  
  class TestEnumerator

  	attr_reader :args

    include IndexManager
    set_enumerator :args
    
  	def initialize(*args)
  		@args = args
  	end

  end

  subject { TestEnumerator.new(1,2,3,4,5)}

  it { expect(subject.args).to eq([1,2,3,4,5]) }
  it { expect(subject).to respond_to(:each) }
  it { expect(subject.enumerator).to eq(subject.args) }
  it { expect(subject.index).to eq(0) }
  it { expect(subject.current).to eq(1)}
  it { expect{subject.up}.to change{subject.current}.from(1).to(2)}
  it { expect{subject.up(2)}.to change{subject.current}.from(1).to(3)}
  it { expect{subject.up(5)}.to change{subject.end?}.from(false).to(true)}
  it { expect(subject.first).to eq(1)}
  it { expect(subject.last).to eq(5)}


  describe '#down' do

    before(:each) do
      subject.up(3)
    end

    it { expect{subject.down}.to change{subject.current}.from(4).to(3)}
    it { expect{subject.down(2)}.to change{subject.current}.from(4).to(2)}
    
  end

end