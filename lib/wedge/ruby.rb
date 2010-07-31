require 'wedge/kernel'
require 'rbconfig'

Wedge.new :Ruby do

  # Notice that rubylibdir takes precendence.
  LOCATIONS = ::RbConfig::CONFIG.values_at(
    'rubylibdir', 'archdir', 'sitelibdir', 'sitearchdir'
  )

  #
  def call(fname, options={})
    return unless md = /^ruby[:\/]/.match(fname)

    file = md.post_match

    LOCATIONS.each do |loadpath|
      if path = find(loadpath, file, options)
        return super(path, options)
      end
    end

    raise LoadError, "no such file to load -- #{fname}"
  end

end

