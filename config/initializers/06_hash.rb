class Hash
  def delete_all(*keys)
    keys.each{|k| self.delete(k)}
  end
end