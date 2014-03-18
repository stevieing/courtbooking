module AppSettings

  #= AppSettings module
  #
  # adds a Kernel constant to manage application wide settings
  #
  # == The variables
  #
  # * const_name: the name of the constant that will be added to the kernel
  # * table_name: the table from which any settings will be loaded
  # * name_column: the table column which forms the constant name
  # * value_column: the table column which forms the value of any constant

  extend self

  mattr_accessor :factory_const_name, instance_accessor: false
  self.factory_const_name = "Settings"

  mattr_accessor :factory_table_name, instance_accessor: false
  self.factory_table_name = "Setting"

  mattr_accessor :const_name
  self.const_name = self.factory_const_name

  mattr_accessor :table_name
  self.table_name = self.factory_table_name

  mattr_accessor :name_column
  self.name_column = :name

  mattr_accessor :value_column
  self.value_column = :value

  mattr_accessor :defaults, instance_writer: false
  self.defaults = {}

  class Options < OpenStruct
  end

  def const
    self.const_name.constantize
  end

  #
  # add any module attributes. Usual trick
  #
  # AppSettings.setup do |config|
  #  config.const_name = "MyConstants"
  # end
  #
  def setup
    yield self
  end

  #
  # load any settings from the table and create or recreate the Kernel constant
  #
  def load!
    create_constant load_settings
  end

  #
  # reset the constant and its friends to the default settings on initialize
  # useful in testing for flushing out any badness
  #
  def reset!
    self.const_name = self.factory_const_name
    self.table_name = self.factory_table_name
  end

  #
  # failsafe during test and development for application
  # wide variables
  #
  # add_default :key, :value
  # this will ensure that required variables are available
  # across all environments if the setting is not in the db
  #
  #
  def add_default(key, value)
    self.defaults[key] = value
  end

  #
  # include AppSettings::ModelTrigger
  #
  # Add in to the model which contains the settings
  # when a record is saved the constants will be reloaded
  # this could be injected during initialize however this would
  # only work in production
  #
  module ModelTrigger
    def self.included(base)
      base.class_eval do
        after_save :reload_constants
        def reload_constants
          AppSettings.load!
        end
      end
    end
  end

  private

  def load_settings
    Options.new(records)
  end

  def create_constant(settings)
    Kernel.send(:remove_const, self.const_name) if Kernel.const_defined?(self.const_name)
    Kernel.const_set(self.const_name, settings.dup)
    add_method_missing
  end

  def model
    self.table_name.constantize
  end

  def records
    model.all.pluck(self.name_column, self.value_column).to_h.to_implicit!
  end

  #TODO: need to shore this up so that if constant has not been defined then an error is raised.
  def add_method_missing
    self.const_name.constantize.class_eval do
      def method_missing(name, *args, &block)
        if AppSettings.defaults.keys.include? name
          AppSettings.defaults[name]
        else
          super
        end
      end
    end
  end

end