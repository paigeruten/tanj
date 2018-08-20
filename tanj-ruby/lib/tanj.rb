require 'binding_of_caller'
require 'json'
require 'paint'

require 'tanj/cli'
require 'tanj/frontend'
require 'tanj/logger'
require "tanj/version"

module Tanj
  @@logger = Logger::Stderr.new

  def self.config(options)
    @@logger = options[:logger] unless options[:logger].nil?
  end

  def self.array(name, options = {})
    b = binding.of_caller(1)

    if options[:index]
      options[:index].map! do |idx|
        if idx.is_a? Symbol
          { name: idx, value: b.eval(idx.to_s) }
        elsif idx.is_a? Range
          [
            idx.begin.is_a?(Symbol) ?
              { name: idx.begin, value: b.eval(idx.begin.to_s) } : { value: idx.begin },
            idx.end.is_a?(Symbol) ?
              { name: idx.end, value: b.eval(idx.end.to_s) } : { value: idx.end }
          ]
        else
          idx
        end
      end
    end

    log(caller_locations[0], {
      type: "array",
      value: b.eval(name.to_s),
      name: name,
      options: options
    })
  end

  def self.var(name)
    log(caller_locations[0], {
      type: "variable",
      value: binding.of_caller(1).eval(name.to_s),
      name: name
    })
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
