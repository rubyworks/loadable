require 'loadable/version'
require 'loadable/mixin'
require 'loadable/domain'
require 'loadable/loaders/original_loader'
require 'loadable/loaders/ruby_loader'
require 'loadable/loaders/gem_loader'
require 'loadable/loaders/vendor_loader'
require 'loadable/kernel'

Loadable.register(Loadable::OriginalLoader.new)

