require_relative 'third_part/active_support/core_ext/string/filters'
class String
  def multiline_squish
    split("\n").map(&:squish).join("\n").gsub(/\A\n+/,'').gsub(/\n+\z/,'')
  end
end