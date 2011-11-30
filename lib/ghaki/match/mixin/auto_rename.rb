require 'ghaki/bool/accessors'

module Ghaki #:nodoc:
module Match #:nodoc:
module Mixin #:nodoc:

module AutoRename
  extend Ghaki::Bool::Accessors

  bool_accessor :auto_rename_to_token
  attr_writer   :auto_rename_fields

  def auto_rename_fields
    @auto_rename_fields || {}
  end

  # Converts 'HTTP Compression' into :http_compression
  def auto_field_name key
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

  def auto_rename_field dirty_key, opts={}
    do_token = opts[:auto_rename_to_token]
    do_token = self.auto_rename_to_token? if do_token.nil?
    to_field = opts[:auto_rename_fields] || self.auto_rename_fields
    clean_key = auto_field_name(dirty_key)
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
