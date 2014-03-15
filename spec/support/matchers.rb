RSpec::Matchers.define :allow_action do |*args|
  match do |permission|
    permission.allow?(*args).should be_true
  end
end

RSpec::Matchers.define :allow_param do |*args|
  match do |permission|
   permission.allow_param?(*args).should be_true
  end
end

RSpec::Matchers.define :have_text do |text|
  match do |cell|
   expect(cell.text).to eq(text)
  end
end

RSpec::Matchers.define :have_klass do |klass|
  match do |cell|
   expect(cell.klass).to eq(klass)
  end
end

RSpec::Matchers.define :be_a_link do
  match do |cell|
   expect(cell.link?).to be_true
  end
end

RSpec::Matchers.define :have_a_span_of do |span|
  match do |cell|
   expect(cell.span).to eq(span)
  end
end

RSpec::Matchers.define :be_a_link_to do |link|
  match do |cell|
   expect(cell.link).to eq(link)
  end
end

RSpec::Matchers.define :be_a_heading do
  match do |row|
   expect(row.heading?).to be_true
  end
end