DependentLoader.start(:allowed_actions) do |on|

  on.success do
    YAML.load_file(File.expand_path(File.join(Rails.root,"config","allowed_actions.yml"))).each do |k,attributes|
      AllowedAction.create(attributes)
    end
  end

end