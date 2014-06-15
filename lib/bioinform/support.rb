require_relative 'support/third_part/active_support/core_ext/string/filters'
require_relative 'support/third_part/active_support/core_ext/hash/indifferent_access'

require_relative 'support/collect_hash'
require_relative 'support/delete_many'
require_relative 'support/multiline_squish'
require_relative 'support/same_by'
require_relative 'support/inverf'
require_relative 'support/deep_dup'

require_relative 'support/partial_sums'

require_relative 'support/array_zip'
require_relative 'support/array_product'

require_relative 'support/advanced_scan'
require_relative 'support/strip_doc'

module Bioinform
  module Support
    # element_indices([:A,:C,:G,:T])  ==>  {:A=>0, :C=>1, :G=>2, :T=>3}
    def self.element_indices(arr)
      arr.each_with_index.inject({}) {|hsh, (letter, index)| hsh.merge(letter => index) }
    end

    # hash_keys_permuted([0,1], :A)  ==>  {[0,1] => :A, [1,0] => :A}
    def self.hash_keys_permuted(key, value)
      key.permutation.inject({}){|hsh, perm| hsh.merge(perm => value) }
    end

    # with_key_permutations({[0,1] => :A, [0,2] => :T})  ==>  {[0,1] => :A, [1,0] => :A, [0,2] => :T, [2,0]=>:T}
    def self.with_key_permutations(hash)
      hash.inject({}) {|h, (indices, letter)| h.merge( hash_keys_permuted(indices, letter) ) }
    end


    # various_key_cases({'a' => 2, 'C' => 3, :g =>5, :T => 8})  ==>  {'a' => 2, 'A' => 2, 'c' => 3, 'C' => 3, :g =>5, :G => 5, :T => 8, :t=>8}
    def self.various_key_cases(hash)
      hash.inject({}){|h,(k,v)| h.merge(k.downcase => v, k.upcase => v) }
    end

    # various_key_types({'a' => 2, 'C' => 3, :g =>5, :T => 8})  ==>  {'a' => 2, :a => 2, 'C' => 3, :C => 3, :g =>5, 'g' => 5, :T => 8, 'T'=>8}
    def self.various_key_types(hash)
      hash.inject({}){|h,(k,v)| h.merge(k.to_s => v, k.to_sym => v) }
    end

    def self.various_key_case_types(hash)
      various_key_types(various_key_cases(hash))
    end


    # various_key_value_cases({:A => :T})  ==>  {:A => :T, :a => :t}
    def self.various_key_value_cases(hash)
      hash.inject({}){|h,(k,v)| h.merge(k.upcase => v.upcase, k.downcase => v.downcase) }
    end

    # various_key_value_types({:A => :T})  ==>  {:A => :T, 'A' => 'T'}
    def self.various_key_value_types(hash)
      hash.inject({}){|h,(k,v)| h.merge(k.to_s => v.to_s, k.to_sym => v.to_sym) }
    end

    def self.various_key_value_case_types(hash)
      various_key_value_types(various_key_value_cases(hash))
    end
  end
end
