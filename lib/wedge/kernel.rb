module Kernel
  alias_method :require_without_wedge, :require
  alias_method :load_without_wedge, :load
end

#
class Wedge

  REGISTRY = []

  def self.registry
    REGISTRY
  end

  def self.register(wedge)
    registry << wedge
  end

  #
  def self.require(fname, options={})
    options[:load] = false
    success = nil
    registry.each do |wedge| 
      success = wedge.call(fname, options)
      next if success.nil?
    end
    success
  end

  #
  def self.load(fname, options={})
    options = Hash===options ? options : {:wrap=>options}
    options[:load] = true
    success = nil
    registry.each do |wedge| 
      success = wedge.call(fname, options)
      next if success.nil?
    end
    success
  end

  #
  module Helper

    # TODO: Some extensions are platform specific --only add the ones needed
    # for the current platform.
    SUFFIXES = ['.rb', '.rbw', '.so', '.bundle', '.dll', '.sl', '.jar'] #, '']

    alias_method :require, :require_without_wedge
    alias_method :load, :load_without_wedge

    # Good idea?
    def self.extended(base)
      Wedge.register base
    end

    #
    def call(fname, options={})
      if options[:load]
        load(fname, options[:wrap])
      else
        require(fname)
      end
    end

    # Given a +loadpath+, a file's relative path, +relname+, and 
    # options hash, determine a matching file exists. Unless +:load+
    # option is +true+, this will check for each viable Ruby suffix.
    # If a match is found the full path to the file is returned,
    # otherwise +nil+.
    def find(loadpath, relname, options={})
      if options[:load] or SUFFIXES.include?(File.extname(relname))
        abspath = File.join(loadpath, relname)
        File.exist?(abspath) ? abspath : nil
      else
        SUFFIXES.each do |ext|
          abspath = File.join(loadpath, relname + ext)
          return abspath if File.exist?(abspath)
        end
      end
      nil
    end

    #
    def raise_load_error(fname)
      raise LoadError, "no such file to load -- #{fname}"
    end

  end

  #
  include Helper

  # Create a new Load Wedge and automatically register it.
  # The +name+ argument is used to identify the Wedge when
  # an error occurs. The block is evaluated in the object's 
  # singleton class.
  def initialize(name, &block)
    @name = name
    (class << self; self; end).class_eval(&block)
    Wedge.register(self)
  end

end


module Kernel
  #
  def require(fname, options={})
    success = Wedge.require(fname, options)
    if success.nil?
      success = require_without_wedge(fname)
    end
    success
  end

  #
  def load(fname, options={})
    success = Wedge.load(fname, options)
    if success.nil?
      success = load_without_wedge(fname)
    end
    success
  end
end

