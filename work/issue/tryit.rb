$LOAD_PATH.unshift('./fixture')

require '/usr/local/lib/ruby/1.9.1/abbrev.rb'

raise unless Abbrev

require 'abbrev'

raise unless AltAbbrev

puts "Looks good!"

