require 'ghaki/match/parser/base'

module Ghaki  #:nodoc:
module Match  #:nodoc:
module Parser #:nodoc:

class Boolean < Base

  DEFAULT_VALUES = {
    true  => %w{ TRUE  YES ON  ENABLED  },
    false => %w{ FALSE NO  OFF DISABLED },
  }

  attr_writer :boolean_lookup

  def boolean_lookup
    @boolean_lookup || []
  end

  def initialize opts={}; super( {}, opts )
    opts_boolean opts
  end

  def opts_boolean opts
    @boolean_lookup = opts[:boolean_lookup]
    add_trues(  opts[:boolean_trues ]  ) unless opts[:boolean_trues].nil?
    add_falses( opts[:boolean_falses]  ) unless opts[:boolean_falses].nil?
    add_words(  DEFAULT_VALUES         ) unless opts[:skip_boolean_defaults]
  end

  def add_trues *list
    add_words( true => [list].flatten )
  end

  def add_falses *list
    add_words( false => [list].flatten )
  end

  # Determine truthiness, return if it is.
  # - Otherwise return original value or yield if block is given.
  def parse_value val, opts={}, &block
    match_text( val, { :default_value => val }.merge(opts), &block )
  end

  # Check whether key is a known boolean field, if so, get truthiness.
  def parse_field key, val, opts={}, &block
    looky = opts[:boolean_lookup] || self.boolean_lookup
    if looky.member?(key)
      parse_value( val, opts, &block )
    else
      val
    end
  end

end
end end end
