describe Activity do
	describe Activity::Event do

		subject {build(:event)}

    it_behaves_like "an STI class"

	end
  
end