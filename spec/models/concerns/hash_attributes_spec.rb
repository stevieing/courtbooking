require 'spec_helper'

describe HashAttributes do

  class TestHashAttributes

    include HashAttributes

    hash_attributes :attr_a, :attr_b, :attr_c

    def initialize(attributes)
      set_attributes(attributes)
    end

  end

  class TestHashAttributesWithDefaults < TestHashAttributes

  private

    def default_attributes
      { attr_a: "a", attr_b: 2}
    end

  end

  describe 'no defaults' do

    subject { TestHashAttributes.new(attr_a: "aaa", attr_b: "bbb", attr_c: "ccc")}

    it { expect(subject.attr_a).to eq("aaa")}
    it { expect(subject.attr_b).to eq("bbb")}
    it { expect(subject.attr_c).to eq("ccc")}
  end

  describe 'defaults' do

    context 'no override' do
      subject { TestHashAttributesWithDefaults.new(attr_c: "ccc")}

      it { expect(subject.attr_a).to eq("a")}
      it { expect(subject.attr_b).to eq(2)}
      it { expect(subject.attr_c).to eq("ccc")}
    end

     context 'override' do
      subject { TestHashAttributesWithDefaults.new(attr_a: "aaa", attr_b: "bbb", attr_c: "ccc")}

      it { expect(subject.attr_a).to eq("aaa")}
      it { expect(subject.attr_b).to eq("bbb")}
      it { expect(subject.attr_c).to eq("ccc")}
    end
  end
end