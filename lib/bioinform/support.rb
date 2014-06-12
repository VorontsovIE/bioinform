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
require_relative 'support/parameters'
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
  end
end
