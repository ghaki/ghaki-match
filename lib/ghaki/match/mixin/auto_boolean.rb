require 'ghaki/match/parser/boolean'

module Ghaki  #:nodoc:
module Match  #:nodoc:
module Mixin  #:nodoc:

module AutoBoolean

  attr_writer :auto_boolean_matcher

  def auto_boolean_matcher
    @auto_boolean_matcher ||= Ghaki::Match::Parser::Boolean.new
  end

  def boolean_lookup
    auto_boolean_matcher.boolean_lookup
  end

  def boolean_lookup= val
    auto_boolean_matcher.boolean_lookup= val
  end

  def boolean_value val, opts={}, &block
    auto_boolean_matcher.parse_value( val, opts, &block )
  end

  def boolean_field key, val, opts={}, &block
    auto_boolean_matcher.parse_field( key, val, opts, &block )
  end

end
end end end
