class Array
  def extract_hash_keys
    self.collect{ |v| v.is_a?(::Hash) ? v.flatten.first : v}
  end

  def symbolize
    self.collect{ |v| v.to_sym }
  end

  def wrap(wrapper)
    self.unshift(wrapper).push(wrapper)
  end

  def cap(capper)
    self.unshift(capper)
  end

end