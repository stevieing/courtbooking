module BookingSlots

	class Cell

		attr_accessor :text, :link, :klass, :span

		def initialize(text = "&nbsp;", link = nil, span=1, klass=nil)
			@text, @link, @span, @klass = text, link, span, klass
		end

		def link?
			!link.nil?
		end

		def add(&block)
			yield self if block_given?
		end

		def valid?
			!@text.empty?
		end

		def inspect
			"<#{self.class}: @text=\"#{@text}\", @link=#{@link}, @class=#{@klass}, @span=#{@span}>"
		end

	end

	class NullCell
		def valid?
			false
		end
	end
end