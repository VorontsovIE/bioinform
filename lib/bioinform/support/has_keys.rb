class Hash
  def has_all_keys?(*keys)
    keys.all?{|key| has_key? key}
  end
  def has_any_key?(*keys)
    keys.any?{|key| has_key? key}
  end
  def has_none_key?(*keys)
    keys.none?{|key| has_key? key}
  end
  def has_one_key?(*keys)
    keys.one?{|key| has_key? key}
  end
end