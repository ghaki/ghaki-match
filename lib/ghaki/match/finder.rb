module Ghaki #:nodoc:
module Match #:nodoc:

# Match against list of regular expressions.
class Finder

  attr_accessor :lookups

  # Given list of regular expressions
  def initialize arg_rx_list
    @lookups = arg_rx_list
  end

  # Matches string against saved regexps.
  def match_text text
    @lookups.each do |rx_curr|
      return true if text =~ rx_curr
    end
    false
  end

  # Matches any line against saved regexps.
  def match_lines lines
    lines.each do |text|
      return true if self.match_text( text )
    end
    false
  end

end
end end
