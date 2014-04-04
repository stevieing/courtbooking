require 'spec_helper'

describe ActiveRecord::Relation do

  with_model :TestArRelation do
    table do |t|
      t.string :name
      t.string :value
      t.string :atype
    end
  end

  let!(:record1) { TestArRelation.create(name: "name1", value: "1", atype: "a")}
  let!(:record2) { TestArRelation.create(name: "name2", value: "2", atype: "a")}
  let!(:record3) { TestArRelation.create(name: "name3", value: "3", atype: "b")}
  let!(:record4) { TestArRelation.create(name: "name4", value: "1", atype: "b")}
  let!(:record5) { TestArRelation.create(name: "name5", value: "2", atype: "c")}

  subject { TestArRelation.all }

  describe '#select_by_attributes' do

    it { expect(subject).to respond_to(:select_with)}
    it { expect(subject.select_with(name: "name1")).to be_instance_of(Array)}
    it { expect(subject.select_with(name: "name1")).to have(1).item}
    it { expect(subject.select_with(name: "name1")).to include(record1)}

    it { expect(subject.select_with(atype: "a")).to have(2).items}
    it { expect(subject.select_with(atype: "a")).to include(record2)}

    it { expect(subject.select_with(name: "name4", value: "1")).to have(1).items}
    it { expect(subject.select_with(name: "name4", value: "1")).to include(record4)}

  end

  describe '#select_first_or_initialize_by' do

    let!(:relations) { TestArRelation.all}

    context 'a record' do
      subject {
        relations.select_first_or_initialize(name: "name1", value: "1") do |relation|
          relation.atype = "d"
        end
      }

      it { expect(subject).to eq(record1)}
      it { expect(subject.atype).to eq("a")}
    end

    context 'no record' do
      subject {
        relations.select_first_or_initialize(name: "name6", value: "6") do |relation|
          relation.atype = "d"
        end
      }

      it { expect(subject).to be_instance_of(TestArRelation)}
      it { expect(subject).to be_new_record}
      it { expect(subject.name).to eq("name6")}
      it { expect(subject.value).to eq("6")}
      it { expect(subject.atype).to eq("d")}
    end

    context 'multiple records' do
      subject {
        relations.select_first_or_initialize(value: "1") do |relation|
          relation.atype = "d"
        end
      }

      it { expect(subject).to eq(record1)}
      it { expect(subject.name).to eq("name1")}
      it { expect(subject.atype).to eq("a")}

    end

  end
end