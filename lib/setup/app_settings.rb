###
# adds a Kernel constant to manage application wide settings
module AppSettings

  #= AppSettings module

  #
  # == The variables
  #
  # * const_name: the name of the constant that will be added to the kernel
  # * table_name: the table from which any settings will be loaded
  # * name_column: the table column which forms the constant name
  # * value_column: the table column which forms the value of any constant

  extend self

  ##
  # Default setting for the constant name.
  # It is not accessible.
  mattr_accessor :factory_const_name, instance_accessor: false
  self.factory_const_name = "Settings"

  ##
  # Default setting for the model name.
  # It is not accessible
  mattr_accessor :factory_model_name, instance_accessor: false
  self.factory_model_name = "Setting"

  ##
  # The name of the Kernel constant.
  # Defaults to the factory constant name.
  mattr_accessor :const_name
  self.const_name = self.factory_const_name

  ##
  # The name of the model which holds the data.
  # Defaults to the factory table name.
  mattr_accessor :model_name
  self.model_name = self.factory_model_name

  ##
  # The attribute which holds the name of the constant
  mattr_accessor :name_column
  self.name_column = :name

  ##
  # The attribute which holds the value of the constant
  mattr_accessor :value_column
  self.value_column = :value

  class Options < OpenStruct
  end

  ##
  # The constant.
  def const
    self.const_name.constantize
  end

  #
  # add any module attributes. Usual trick
  #
  #  AppSettings.setup do |config|
  #   config.const_name = "MyConstants"
  #  end
  #
  def setup
    yield self
  end

  ##
  # load any settings from the table and create or recreate the Kernel constant
  def load!
    create_constant load_settings
  end

  ##
  # reset the constant and its friends to the default settings on initialize
  # useful in testing for flushing out any badness
  def reset!
    self.const_name = self.factory_const_name
    self.model_name = self.factory_model_name
  end

  #
  #
  # Add in to the model which contains the settings
  # when a record is saved the constants will be reloaded
  # this could be injected during initialize however this would
  # only work in production.
  # Only works with an ActiveRecord model or one which
  # implements a save method
  # Example:
  #  model MyModel
  #   include AppSettings::ModelTrigger
  #  end
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
  end

  def model
    self.model_name.constantize
  end

  def records
    model.all.pluck(self.name_column, self.value_column).to_h.to_implicit!
  end

end