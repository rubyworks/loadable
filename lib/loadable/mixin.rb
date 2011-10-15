# Loadable is used in two ways.

# First, it can be used as a mixin for loaders (also called load wedges). Loaders
# are used to safely inject new import logic into Ruby's require/load system.
#
# Secondly, Loadable's class methods are used to override Ruby's built-in
# require and load Kernel methods.
#
# Active load wedges are stored in `$LOADERS` global variable.
#
# IMPORTANT: This must be loaded before `loadable/kernel.rb`.

module Loadable

  # TODO: Some extensions are platform specific --only add the ones needed
  # for the current platform.

  # Script extensions recognized by Ruby (MRI and variants).
  RB_EXTS = ['.rb', '.rbw', '.so', '.bundle', '.dll', '.sl', '.jar'] #, '']

  alias :require :require
  alias :load    :load

  #
  def call(fname, options={})
    if options[:load]
      load(fname, options[:wrap])
    else
      require(fname)
    end
  end

  # A load wedge should provide a means for iterating over all requirable
  # files that its `#call` method could load.
  #
  # If a load wedge is "esoteric", in that it doesn't actually load
  # a file, then it's `#each` method can iterate over a list of suitable
  # symbolic identifiers, or if otherwise necessary nothing at all. But
  # be sure to document this prominantly!!!
  #
  def each(options={}, &block)
  end

  # Name of wedge. By default it is simply the class name.
  def name
    self.class.name
  end

private

  # Given a base-path, and a path relative to it determine if a matching
  # file exists. Unless +:load+ option is +true+, this will check for each
  # viable Ruby suffix. If a match is found the full path to the file
  # is returned, otherwise +nil+.

  def lookup(base_path, relative_path, options={})
    exts = default_file_extensions
    if options[:load] or exts.include?(File.extname(relative_path))
      abspath = File.join(base_path, relative_path)
      File.exist?(abspath) ? abspath : nil
    else
      exts.each do |ext|
        abspath = File.join(base_path, relative_path + ext)
        return abspath if File.exist?(abspath)
      end
      nil
    end
  end

  # This helper method provides a fast way to traverse a directory
  # recursively iteratating over each file.

  def traverse(dir, base=dir, &block)
    return unless File.directory?(dir)
    Dir.new(dir).each do |file|
      next if file == '.' or file == '..'
      path = File.join(dir, file)
      if File.directory?(path)
        traverse(path, base, &block)
      else
        block.call(path.sub(base+'/',''))
      end
    end
  end

  # This method is used by `#lookup` to handle defualt file extensions.
  # By default it returns the value of the `RB_EXTS` constant.

  def default_file_extensions
    RB_EXTS
  end

  # Raise LoadError with an error message patterned after Ruby's standard 
  # error message when a script can't be required or loaded.

  def raise_load_error(fname)
    raise LoadError, "no such file to load -- #{fname}"
  end

end
