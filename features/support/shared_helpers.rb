Dir[
  File.expand_path(
  Rails.root.join 'spec','support','shared', '**', '*.rb'
)
].each do |f| 
  require f
  World(f.split("/").last.gsub(".rb","").camelize.constantize) if respond_to?(:World)
end

