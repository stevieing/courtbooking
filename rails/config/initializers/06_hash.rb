class Hash
  def delete_all(*keys)
    keys.each{|k| self.delete(k)}
  end

  # convert each key to a symbol
  # convert each value to its implicit type
 	# in this case integer or time. Anything else is left alone.
  def to_implicit!
    {}.tap do |h|
      self.each do |k, v|
        h[k.to_sym] = (v.class == String ? v.to_type : v)
      end
    end
  end

end