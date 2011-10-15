module Kernel

  # Aliases for original load and require.
  alias_method :load0,    :load
  alias_method :require0, :require

  # TODO: I am not certain `:load` is the best name for this option.
  # Something like `:eval` is more meaningful. OTOH, we could flip
  # it about and use `:feature` or `:cache` to mean the opposite.

  #
  def require(fname, options={})
    options[:load] = false unless options.key?(:load)
    Loadable.call(fname, options)
    #success = LoadSystem.require(fname, options)
    #if success.nil?
    #  success = require_without_wedge(fname)
    #end
    #success
  end

  #
  def load(fname, options={})
    options = Hash===options ? options : {:wrap=>options}
    options[:load] = true unless options.key?(:load)
    Loadable.call(fname, options)
    #success = LoadSystem.load(fname, options)
    #if success.nil?
    #  success = load_without_wedge(fname)
    #end
    #success
  end

end

