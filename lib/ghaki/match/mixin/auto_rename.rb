require 'ghaki/bool/accessors'

module Ghaki #:nodoc:
module Match #:nodoc:
module Mixin #:nodoc:

module AutoRename
  extend Ghaki::Bool::Accessors

  bool_accessor :auto_tokenize
  attr_writer   :field_renames

  def field_renames
    @field_renames || {}
  end

  # Converts 'HTTP Compression' into :http_compression
  def format_field key
    key.downcase.gsub(%r{[^A-Z0-9]+}xoi,' ').strip.gsub(' ','_')
  end

  # Given a string, convert it using #easy_name
  # - if the rename table does not exist, return the converted string
  # - if the rename table exists, and has an entry for that converted value
  #   - if the entry is a token, return the table's token entry
  #   - if the entry is true, then just tokenize the converted string
  #   - if the entry is false, then pass through the converted string
  #   - otherwise, complain about the invalid value
  # - if the rename table exists, and does NOT have an entry
  #   - return the string

  def rename_field dirty_key, opts={}
    do_token = opts[:auto_tokenize]
    do_token = self.auto_tokenize? if do_token.nil?
    to_field = opts[:field_renames] || self.field_renames
    clean_key = format_field(dirty_key)
    field_key = to_field[clean_key]
    field_key = do_token if field_key.nil? and (not do_token.nil?)
    case field_key
    when Symbol then field_key
    when true   then clean_key.to_sym
    when false  then clean_key
    else
      raise ArgumentError, "Unknown Auto Rename Field Value: #{clean_key}"
    end
  end

end
end end end
