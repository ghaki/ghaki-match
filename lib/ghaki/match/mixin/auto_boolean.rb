require 'ghaki/match/parser/boolean'

module Ghaki  #:nodoc:
module Match  #:nodoc:
module Mixin  #:nodoc:

module AutoBoolean

  attr_writer :auto_boolean_matcher

  def auto_boolean_matcher
    @auto_boolean_matcher ||= Ghaki::Match::Parser::Boolean.new
  end

  def auto_boolean_fields
    auto_boolean_matcher.boolean_fields
  end

  def auto_boolean_fields= val
    auto_boolean_matcher.boolean_fields = val
  end

  def auto_boolean_value val, opts={}, &block
    auto_boolean_matcher.parse_value( val, opts, &block )
  end

  def auto_boolean_field key, val, opts={}, &block
    auto_boolean_matcher.parse_field( key, val, opts, &block )
  end

end
end end end
