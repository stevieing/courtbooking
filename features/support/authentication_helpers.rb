module AuthenticationHelpers
  def create_attributes(text)
    Hash[text.gsub('"','').split(" and ").collect { |param| param.split(": ")}]
  end
end

World(AuthenticationHelpers)