module BookingSlots

	class Cell

		attr_accessor :text, :link, :klass, :span

		def initialize(text = "&nbsp;", link = nil, span=1, klass=nil)
			@text, @link, @span, @klass = text, link, span, klass
		end

		def link?
			!link.nil?
		end

		def add(record)
			record.instance_variables.each do |attribute|
				instance_variable_set(attribute.to_s, record.send(attribute.to_s.gsub('@','').to_sym))
			end
		end

		def valid?
			!@text.empty?
		end

		def inspect
			"<#{self.class}: @text=\"#{@text}\", @link=#{@link}, @class=#{@klass}, @span=#{@span}>"
		end

	end

end