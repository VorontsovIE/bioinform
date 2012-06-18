class Array
  def partial_sums(initial = 0.0)
    sums = initial
    map{|el| sums += el}
  end
end
