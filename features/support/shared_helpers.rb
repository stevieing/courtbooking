Dir[
  File.expand_path(
  Rails.root.join 'spec','support','shared', '**', '*.rb'
)
].each do |f| 
  require f
  World(f.split("/").last.gsub(".rb","").camelize.constantize) if respond_to?(:World)
end

Capybara.add_selector(:id) do
  xpath { |id| XPath.descendant[XPath.attr(:id) == id.to_s] }
end