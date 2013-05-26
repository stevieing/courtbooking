Dir[
  File.expand_path(
  Rails.root.join 'spec','support','shared', '**', '*.rb'
)
].each {|f| require f}

World(ManageSettings) if respond_to?(:World)

module FactoryAttributeHelpers
  def create_attributes(text)
    Hash[text.gsub('"','').split(" and ").collect { |param| param.split(": ")}]
  end
end

World(FactoryAttributeHelpers)