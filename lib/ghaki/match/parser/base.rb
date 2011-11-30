module Ghaki  #:nodoc:
module Match  #:nodoc:
module Parser #:nodoc:

# Matches against paired regular expressions and returned values.
class Base

  attr_accessor :lookups, :default_value

  def initialize pairs={}, opts={}
    @lookups = pairs
    @default_value = opts[:default_value]
    add_words( opts[:match_words] ) if opts.has_key?(:match_words)
  end

  # Add simple words with return values to match pairs.
  # - Keys are return values, values are words to turn into regexps.
  #
  # Given:
  #
  #   add_words :up => %w{ ON UP }, :down => %w{ DOWN OFF }
  # 
  # This will match against 'ON' and 'UP' and return :up
  # and match against 'DOWN' and 'OFF' and return :down
  def add_words pairs
    pairs.each_pair do |val,keyz|
      keyz.each do |key|
        @lookups[ %r{\b#{key}\b}i ] = val
      end
    end
  end

  # Matches lines against regexp keys returning paired value.
  # - Yields on not found or returns default value.
  def match_lines lines, opts={}
    @lookups.each_pair do |rx_curr,ret_val|
      lines.each do |text|
        return ret_val if text =~ rx_curr
      end
    end
    if block_given?
      yield
    elsif opts.has_key?(:default_value)
      opts[:default_value]
    else
      @default_value
    end
  end

  # Matches string against regexp keys returning paired value.
  # - Yields on not found or returns default value.
  def match_text text, opts={}
    @lookups.each_pair do |rx_curr,ret_val|
      return ret_val if text =~ rx_curr
    end
    if block_given?
      yield
    elsif opts.has_key?(:default_value)
      opts[:default_value]
    else
      @default_value
    end
  end

end
end end end
