
class VendorLoader < Loader

  # Add vendored projects to load path. For example:
  #
  #   $LOAD_PATH.vendor(project_root_directoy, 'vendor')
  #
  # Then any projects in the vendor directory will be accessible
  # via require and load. This method looks for a .gemspec or .ruby
  # file in the project to determine it's proper load paths, baring
  # either of these it falls back to using `lib/`.
  #
  def self.vendor(*directory)
    raise ArgumentError if directory.empty?

    opt = Hash === directory.last ? directory.pop : {}
    dir = File.expand_path(File.join(*directory))

    return $:.unshift(dir) if opt[:direct]

    gemspecs = Dir.glob(File.join(dir, '*/{*,}.gemspec'))
    dotrubys = Dir.glob(File.join(dir, '*/.ruby'))
    libpaths = Dir.glob(File.join(dir, '*/lib'))

    # TODO: if no paths fallback to direct path --good idea?
    return $:.unshift(dir) if gemspecs.empty? && dotrubys.empty? && libpaths.empty?

    # TODO: more efficient means of prevent duplicate paths?
    index = []

    dotrubys.each do |path|
      root = File.dirname(path)
      next if index.include?(root)
      index << root

      spec = YAML.load(path)
      spec['load_path'].each do |lp|
        $:.unshift(File.join(root, rp))
      end
    end

    if defined?(::Gem) # only if rubygems is in use
      gemspecs.each do |path|
        root = File.dirname(path)
        next if index.include?(root)
        index << root

        # TODO: handle YAML gemspecs
        spec = Gem::Specification.load(path)
        spec.require_paths.each do |rp|
          $:.unshift(File.join(root, rp))
        end
      end
    end

    libpaths.each do |path|
      root = File.dirname(path)
      next if index.include?(root)
      index << root

      $:.unshift(path)
    end

    return $:
  end

end
