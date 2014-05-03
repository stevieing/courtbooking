module IndexSplitter

  extend ActiveSupport::Concern
  include IndexManager

  included do
  end

  module ClassMethods

    def set_enumerator_with_split(enumerator, split)
      set_enumerator enumerator
      define_method :splitter do
        instance_variable_get("@#{split.to_s}")
      end
      attr_reader split
    end
  end

  def split?
    (index > 0 && index % splitter == 0) || end?
  end

end