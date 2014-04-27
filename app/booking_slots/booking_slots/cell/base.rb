module BookingSlots
  module Cell
    class Base

      def self.build(*args)
        new(*args)
      end

      attr_accessor :text, :link, :klass, :span

      def link?
        link.present?
      end

      # def add(record)
      #   record.instance_variables.each do |attribute|
      #     instance_variable_set(attribute.to_s, record.send(attribute.to_s.gsub('@','').to_sym))
      #   end
      # end

      def valid?
        true
      end

      def active?
        false
      end

      def closed?
        false
      end

      def span
        @span ||= 1
      end

      def inspect
        "<#{self.class}: @text=\"#{@text}\", @link=#{@link}, @class=#{@klass}, @span=#{@span}>"
      end
    end
  end
end