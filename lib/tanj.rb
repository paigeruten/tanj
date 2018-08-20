require 'json'
require 'paint' # TODO: bundler this

require 'tanj/frontend'
require 'tanj/logger'

module Tanj
  @@logger = Logger::Stderr.new

  def self.config(options)
    @@logger = options[:logger] unless options[:logger].nil?
  end

  def self.array(value, name, options = {})
    log(caller_locations[0], type: "array", value: value, name: name, options: options)
  end

  def self.var(value, name)
    log(caller_locations[0], type: "variable", value: value, name: name)
  end

  def self.message(msg)
    log(caller_locations[0], type: "message", message: msg)
  end

  def self.here
    log(caller_locations[0], type: "here")
  end

  private

  def self.log(location, hash)
    hash[:where] = {line_num: location.lineno, path: location.absolute_path, label: location.label}
    @@logger.log "tanj| #{hash.to_json}"
  end
end
