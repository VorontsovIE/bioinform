require 'active_support/core_ext/string/filters'
class String
  def multiline_squish
    split("\n").map(&:squish).drop_while(&:empty?).take_while{|line| !line.empty?}.join("\n")
  end
end