class Array
	def wrap(wrapper)
		self.unshift(wrapper).push(wrapper)
	end

  def cap(capper)
    self.unshift(capper)
  end
end

module BookingSlots

	module Wrapper
		extend ActiveSupport::Concern

		included do
		end

		module ClassMethods
			def wrap(to_wrap, wrapper)
        bind_method :wrap, to_wrap, wrapper
			end

      def cap(to_cap, capper)
        bind_method :cap, to_cap, capper
      end

      def bind_method(method, inner, outer)
        original = "original #{inner}"

        alias_method original, inner

        define_method(inner) do |*args|
          send(original, *args).send(method, send(outer))
        end
      end
		end

	end

end