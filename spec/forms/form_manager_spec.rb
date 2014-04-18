require 'spec_helper'

describe FormManager do

  let(:params) { { attr_a: "a", attr_b: "b", attr_c: "c", attr_d: 1}.with_indifferent_access }
  let(:nested_params) { {nested_models: { "1" => {attr_g: "g", attr_h: "h"}, "2" => { attr_g: "g", attr_h: "h" }}}}
  let(:nested_params_invalid) { {nested_models: { "1" => {attr_h: "h"}, "2" => { attr_g: "g", attr_h: "h" }}}}
  let(:nested_params_update) { {nested_models: { "1" => {attr_g: "h", attr_h: "i"}, "2" => { attr_g: "j", attr_h: "k" }}}}

  with_model :NestedModel do
    table do |t|
      t.string :attr_g
      t.string :attr_h
      t.integer :my_model_id
    end
    model do
      validates_presence_of :attr_g
    end
  end

  with_model :MyModel do
    table do |t|
      t.string  :attr_a
      t.string  :attr_b
      t.string  :attr_c
      t.integer :attr_d
      t.string  :attr_e
      t.string  :attr_f
    end
    model do
      has_many :nested_models, dependent: :destroy
      validates_presence_of :attr_a, :attr_b, :attr_c, :attr_d
      validates_numericality_of :attr_d
    end
  end

  with_model :CascadedModel do
    table do |t|
      t.string :attr_i
    end
  end

  before(:each) do
    class MyModelForm
      include FormManager
      set_model :my_model, [:attr_a, :attr_b, :attr_c, :attr_d, :attr_e, :attr_f]
      set_associated_models :nested_models
      validate :verify_associated_models
      validate :verify_my_model
      add_initializer(:attr_e) do
        Date.today
      end
    end
  end

  describe "includes" do
    it { expect(MyModelForm).to include(ActiveModel::Model)}
    it { expect(MyModelForm.model_name).to eq("MyModel")}
  end

  describe '#model' do
    subject { MyModelForm.new }

    it { expect(subject).to respond_to(:attr_a, :attr_b, :attr_c, :attr_d)}
    it { expect(subject).to_not be_persisted }
  end

  describe '#submit' do

    subject {  MyModelForm.new }

    context 'valid' do
      before(:each) do
        subject.submit(params)
      end

      it { expect(subject.attr_a).to eq("a")}
      it { expect(subject.attr_b).to eq("b")}
      it { expect(subject.attr_c).to eq("c")}
      it { expect(subject.attr_d).to eq(1)}
      it { expect(subject).to be_valid }
      it { expect(MyModel.all).to have(1).item }
      it { expect(subject.nested_models).to have(0).items}
    end

    context 'invalid' do

      describe 'missing attribute' do
        before(:each) do
          subject.submit(params.except(:attr_c))
        end

        it { expect(subject.attr_c).to be_nil }
        it { expect(subject).to_not be_valid }
        it { expect(subject.errors).to have(1).item}
        it { expect(subject.errors.full_messages.first).to eq("Attr c can't be blank")}
        it { expect(MyModel).to have(0).items }
      end

       describe 'invalid attribute' do
        before(:each) do
          subject.submit(params.merge(:attr_d => "d"))
        end

        it { expect(subject.attr_d).to eq(0) }
        it { expect(subject).to_not be_valid }
        it { expect(subject.errors).to have(1).item}
        it { expect(subject.errors.full_messages.first).to eq("Attr d is not a number")}
        it { expect(MyModel).to have(0).items }
      end

    end

  end

  describe '#initializers' do

    subject {  MyModelForm.new }

    it { expect(subject.attr_e).to eq(Date.today)}
  end

  describe 'associated_models' do

    context 'valid' do

      subject { MyModelForm.new }

      before(:each) do
        subject.submit(params.merge(nested_params).with_indifferent_access)
      end

      it { expect(subject.nested_models.count).to eq(2) }
      it { expect(NestedModel.all).to have(2).items}
      it { expect(subject).to be_valid }
      it { expect(subject.nested_models.first.attr_g).to eq("g")}
      it { expect(subject.nested_models.last.attr_h).to eq("h")}

    end

    context 'invalid' do

      subject { MyModelForm.new }

      before(:each) do
        subject.submit(params.merge(nested_params_invalid).with_indifferent_access)
      end


      it { expect(subject.nested_models).to have(2).items }
      it { expect(NestedModel.all).to have(0).items }
      it { expect(subject).to_not be_valid }
      it { expect(subject.nested_models.first.attr_g).to be_nil}
      it { expect(subject.nested_models.last.attr_h).to eq("h")}

    end

  end

  describe 'process paramters' do

    subject { MyModelForm.new }

    before(:each) do
      class MyModelForm
        def process_parameters(params)
          params.tap do |p|
           p[:attr_f] = "#{p[:attr_f]}1" unless p[:attr_f].nil?
          end
        end
      end
      subject.submit(params.merge({"attr_f" => "f"}))
    end

    it { expect(subject).to be_valid}
    it { expect(subject.attr_f).to eq("f1")}

  end

  describe 'update' do

    context 'no nested params' do
      let!(:my_model) { MyModel.create(attr_a: "z", attr_b: "y", attr_c: "x", attr_d: "w")}
      subject         { MyModelForm.new(my_model) }

      before(:each) do
        subject.submit(params)
      end

      it { expect(subject).to be_valid}
      it { expect(subject).to be_persisted}
      it { expect(subject.attr_a).to eq("a")}
      it { expect(subject.attr_b).to eq("b")}
      it { expect(subject.attr_c).to eq("c")}
      it { expect(subject.attr_d).to eq(1)}
      it { expect(subject).to be_valid }
      it { expect(MyModel.all).to have(1).item }

    end

    context 'nested params' do
      let!(:original) { MyModelForm.new.submit(params.merge(nested_params).with_indifferent_access) }
      subject         { MyModelForm.new(MyModel.first) }

      before(:each) do
        subject.submit(params.merge(nested_params_update).with_indifferent_access)
      end

      it { expect(subject).to be_valid}
      it { expect(subject).to be_persisted}
      it { expect(subject.nested_models).to have(2).items }
      it { expect(NestedModel.all).to have(2).items }
      it { expect(subject.nested_models.first.attr_g).to eq("h")}
      it { expect(subject.nested_models.last.attr_h).to eq("k")}

    end

  end

  describe '#new with parameters' do
    subject { MyModelForm.new(params)}

    it { expect(subject.attr_a).to eq("a")}
    it { expect(subject.attr_b).to eq("b")}
    it { expect(subject.attr_c).to eq("c")}
    it { expect(subject.attr_d).to eq(1)}
  end

  describe '#before_save' do
    before(:each) do
      class CascadedModelForm
        include FormManager
        set_model :my_model, [:attr_a, :attr_b, :attr_c, :attr_d, :attr_e, :attr_f]
        validate :verify_my_model
        before_save :create_cascaded_model
        def create_cascaded_model
          mod = CascadedModel.create(attr_i: "i")
        end
      end
      CascadedModelForm.new.submit(params)
    end

    it { expect(CascadedModel.all).to have(1).item }
  end

end