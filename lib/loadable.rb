require 'loadable/version'
require 'loadable/mixin'
require 'loadable/domain'
require 'loadable/loaders/original_loader'
require 'loadable/loaders/ruby_loader'
require 'loadable/loaders/gem_loader'
require 'loadable/loaders/vendor_loader'

$LOADERS = [
  Loadable::GemLoader.new,
  Loadable::RubyLoader.new,
  Loadable::OriginalLoader.new
]

require 'loadable/kernel'

