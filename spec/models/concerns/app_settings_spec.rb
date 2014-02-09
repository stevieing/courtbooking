require "spec_helper"

describe AppSettings do

	after(:all) do
		AppSettings.reset!
	end

	let(:const_name) { AppSettings.const_name }
	let(:table_name) { AppSettings.table_name }

	let(:test_const_name) { "TestSettings" }
	let(:test_table_name) { "TestSetting" }
	let(:dependency) { [:my_dependencies, :attr_a, :attr_b, :attr_c] }

	with_model :TestSetting do
		table do |t|
			t.string :name
			t.string :value
			t.string :description
		end
		model do
			include AppSettings::ModelTrigger
		end
	end

	class MyDependencies
		attr_accessor :attr_a, :attr_b, :attr_c
		def initialize(attributes)
			@attr_a, @attr_b, @attr_c = attributes[:attr_a], attributes[:attr_b], attributes[:attr_c]
		end
		def do_some_stuff
			"#{attr_a} #{attr_b} #{attr_c}"
		end
	end

	before(:each) do
		setup_appsettings test_const_name, test_table_name, dependency
		TestSetting.create(name: :my_name, value: "my value")
		AppSettings.load!
	end

	describe "create" do

		it { TestSettings.should respond_to(:my_name)}
		it { expect(TestSettings.my_name).to eq("my value")}

		context "number" do

			before(:each) do
				TestSetting.create(name: :my_number, value: "999")
			end

			it { TestSettings.should respond_to(:my_number)}
			it { expect(TestSettings.my_number).to be_kind_of(Integer)}
		end

		context "time" do

			before(:each) do
				TestSetting.create(name: :my_time, value: "22:30")
			end

			it { TestSettings.should respond_to(:my_time)}
			it { expect(TestSettings.my_time).to be_instance_of(Time)}
		end
	end

	describe "update" do

		before(:each) do
			TestSetting.first.update_attributes(value: "new value")
		end

		it { expect(TestSettings.my_name).to eq("new value")}

	end

	describe "dependencies" do
		before(:each) do
			TestSetting.create(name: :attr_a, value: "attr A")
			TestSetting.create(name: :attr_b, value: "attr B")
			TestSetting.create(name: :attr_c, value: "attr C")	
		end

		it { TestSettings.should respond_to(:my_dependencies)}
		it { expect(TestSettings.my_dependencies).to be_instance_of(MyDependencies)}
		it { expect(TestSettings.my_dependencies.do_some_stuff).to eq("attr A attr B attr C")}

	end

	describe "reset!" do

		before(:each) do
			AppSettings.reset!
		end

		after(:each) do
			setup_appsettings test_const_name, test_table_name, dependency
		end

		it { expect(AppSettings.const_name).to eq(const_name)}
		it { expect(AppSettings.table_name).to eq(table_name)}
		it { expect(AppSettings.dependencies).to be_empty}
	end

	describe "defaults" do
		before(:each) do
			AppSettings.setup do |config|
				config.add_default :dodgy_setting, 1
			end
		end

		it { expect(TestSettings.dodgy_setting).to eq(1)}

	end
	
end