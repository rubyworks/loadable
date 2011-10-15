# TODO: Support `:from` option.

require 'loadable/mixin'

module Loadable

  # Add vendored projects to load path. For example:
  #
  #   Loadable.vendor(project_root_directoy, 'vendor')
  #
  # Then any projects in the vendor directory will be accessible
  # via require and load. This method looks for a .gemspec or .ruby
  # file in the project to determine it's proper load paths, baring
  # either of these it falls back to using `lib/`.

  class VendorLoader

    include Loadable

    #
    def initialize(*directory)
      raise ArgumentError if directory.empty?

      @_yaml_loaded ||= !(require 'yaml').nil?

      settings  = (Hash === directory.last ? directory.pop : {})
      directory = File.expand_path(File.join(*directory))

      @load_path = []

      if settings[:direct]
        @load_path.concat(Dir.glob(directory))
      else
        Dir.glob(directory).each do |dir|
          next unless File.directory?(dir)
          build_loadpath(dir)
        end
      end

      if @load_path.empty?
        # TODO: if load_path empty should we fallback to direct path ?
      end
    end

    # Load script from vendored locations.
    #
    def call(fname, options={})
      @load_path.each do |path|
        file = lookup(path, fname, options)
        return super(file, options) if file
      end
      raise_load_error(fname)
    end

    # Iterate over each loadable file in vendored locations.
    #
    def each(options={}, &block)
      @load_path.uniq.each do |path|
        path = File.expand_path(path)
        traverse(path, &block)
      end
    end

  private

    # Build up load_path given a directory to check. Looks for a `.ruby`
    # or `.gemspec` file to get project's local load paths, otherwise if
    # looks for a `lib` directory.
    #
    def build_loadpath(dir)
      if dotruby_file = Dir.glob(File.join(dir, '.ruby')).first
        @load_path.concat(loadpath_dotruby(dotruby_file, dir))

      elsif defined?(::Gem) && gemspec = Dir.glob(File.join(dir, '{*,}.gemspec')).first
        @load_path.concat(loadpath_gemspec(gemspec_file, dir))

      elsif path = Dir.glob(File.join(dir, 'lib')).first
        @load_path << path

      else
        # TODO: is this an error, just ignore, or add dir directly ?
      end

      return @load_path
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

end
