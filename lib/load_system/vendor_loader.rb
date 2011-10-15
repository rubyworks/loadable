# Add vendored projects to load path. For example:
#
#   $LOAD_PATH.vendor(project_root_directoy, 'vendor')
#
# Then any projects in the vendor directory will be accessible
# via require and load. This method looks for a .gemspec or .ruby
# file in the project to determine it's proper load paths, baring
# either of these it falls back to using `lib/`.

class VendorLoader < Loader

  def initialize(*directory)
    raise ArgumentError if directory.empty?

    @options   = (Hash === directory.last ? directory.pop : {})
    @directory = File.expand_path(File.join(*directory))
  end

  #
  def call(fname, options={})
    load_path = []

    if @options[:direct]
      load_path.concat Dir.glob(@directory)
    else
      Dir.glob(@directory).each do |dir|
        build_loadpath(dir, load_path)
      end
    end

    if load_path.empty?
      # TODO: if load_path empty should we fallback to direct path ?
    end

    load_path.each do |path|
      if file = lookup(path, fname, options)
        return super(file, options)
      end
    end

    raise_load_error(fname)
  end

private

  # Build up load_path given a directory to check. Looks for a `.ruby`
  # or `.gemspec` file to get project's local load paths, otherwise if
  # looks for a `lib` directory.
  #
  def build_loadpath(dir, load_path=[])
    if dotruby_file = Dir.glob(File.join(dir, '.ruby'))
      load_path.concat(loadpath_dotruby(dotruby_file, dir))

    elsif defined?(::Gem) && gemspec = Dir.glob(File.join(dir, '{*,}.gemspec')).first
      load_path.concat(loadpath_gemspec(gemspec_file, dir))

    elsif path = Dir.glob(File.join(dir, 'lib')).first
      load_path << path

    else
      # TODO: is this an error, just ignore, or add dir directly ?
    end

    return load_path
  end

  # Build the load_path given a '.ruby` file.
  #
  def loadpath_dotruby(dotruby_file, dir)
    data = YAML.load(dotruby_file)
    path = data['load_path'] || ['lib']
    path.map do |lp|
      File.join(dir, lp)
    end
  end

  # Build the load_path given a '.gemspec` file.
  #
  def loadpath_gemspec(gemspec_file, dir)
    # TODO: handle YAML gemspecs
    spec = Gem::Specification.load(gemspec_file)
    spec.require_paths.map do |rp|
      File.join(dir, rp)
    end
  end

end
