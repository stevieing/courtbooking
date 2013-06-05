Transform /^date (.*?)$/ do |date|
  Date.parse(date)
end