# Loadable

## 1 Overview

| Project      | Loadable                                                 |
|--------------|----------------------------------------------------------|
| Author       | Thomas Sawyer                                            |
| License      | BSD-2-Clause                                             |
| Copyright    | (c) 2010 Thomas Sawyer                                   |
| Website      | http://github.com/rubyworks/loadable                     |
| Development  | http://github.com/rubyworks/loadable                     |
| Mailing-List | http://groups.google.com/group/rubyworks-mailinglist     |


## 2 Description

The Loadable gem provides a more robust and convenient means of augmenting
Ruby's load system, namely the `load` and `require` methods. Rather than
alias and override these methods, Loadable keeps a list of *load wedges*
that control the routing of require and load calls.

In addition, the Loadable gem includes two pre-made load wedges that can be
used to prevent name clashes between Ruby's standard library and gem packages
(see INFRACTIONS.rdoc for more on this). There is also a load wedge for
for developers to make it trivial to make vendored sub-projects loadable.


## 3 Usage

### 3.1 Installation

Installing via RubyGems follows the usual pattern.

    $ gem install loadable

To automatically load both the Gem and Ruby wedges, and the entire Loadable
system, add `loadable` to your RUBYOPT environment variable.

    $ export RUBYOPT="-rloadable"

Place this in your shell's configuration file, such as `~/.bashrc`.

If you do not want the default setup you can `require 'loadable/system'` instead.
This will load in Loadable system, but only add an `OriginalLoader` to the
`$LOADERS` list, leaving off the Ruby and Gem loaders.

### 3.2 Custom Loaders

Loadable was written initially to provide the specific capability of loading
Ruby standard libraries without potential interference from libraries
installed via RubyGems (see INFRACTIONS.rdoc). The code ultimately evolved
into a more generic tool, useful for writing any kind of plug-in load
router. 

The code for the Ruby wedge serves as a good example of writing a load wedge.
(Note this is leaves out a few details of the real class for simplicity sake.)

    require 'rbconfig'
    require 'loadable/mixin'

    class Loadable::RubyLoader
      include Loadable

      LOCATIONS = ::RbConfig::CONFIG.values_at(
        'rubylibdir', 'archdir', 'sitelibdir', 'sitearchdir'
      )

      def call(fname, options={})
        return unless options[:from].to_s == 'ruby'
        LOCATIONS.each do |loadpath|
          if path = lookup(loadpath, fname, options)
            return super(path, options)
          end
        end
        raise_load_error(fname)
      end

      def each(options={}, &block)
        LOCATIONS.each do |loadpath|
          traverse(loadpath, &block)
        end
      end
    end

To put this loader into action we simply need to register it with the Loadable 
domain.

    Loadable.register(Loadable::RubyLoader.new)

Under the hood, this simply appends the instance to the `$LOADERS` global variable.

Loaders, also called load wedges, are easy to write as their interface is very
simple. Any object the responds to #call, taking parameters of 
<code>(fname, options={})</code>, can be used as a load wedge. A load wedge
should also support `#each(options={}, &block)` which is used to iterate over
all requirable files a loader supports.

The `Loadable` mixin is just a convenience module that makes writing loaders
a bit easier. Load wedges can be written without it, however the mixin
provides a few methods that are often useful to any load wedge. An example is
the `lookup` method used in the above example, which will search a
load path in accordance with the Ruby's built-in require and load lookup
procedures, i.e. automatically trying defualt extensions like `.rb`.

You might wonder how the single method, `#call`, handles both load and require
operations. The secret is in the `options` hash. If <code>options[:load]</code>
resolves to true, then it is a *load* operation, otherwise it is a *require*
operation. The `$LOADERS` global variable is iterated over in order.
When `#load` or `#require` is called each wedge is tried in turn. The return
value of `#call` controls how this loop proceeds. If the return value is `true`
then the load was successful, and the loop can break. If it is `false` it means
the loading has already been handled and the loop can also break. But if the
return value is `nil`, it means the wedge does not apply and the loop should
continue. If all wedges have been tried and all have returned `nil` then it
falls back to the original `#load` and `#require` calls, via an instance
`OriginalLoader` which should always be the last loader in the `$LOADERS` list.


## 4 Built-in Loaders

The Loadable gem provides three special loaders out-of-the-box, the `RubyLoader`,
the `GemLoader` and the `VendorLoader`. The first two are probably not exaclty
what you think they are, going just by their names, so keep reading...

### 4.1 RubyLoader

The Ruby wedge makes it possible to load a Ruby standard library without
interference from installed gems or other package systems. It does this by 
checking for a `:from` option passed to the require or load methods.

    require 'ostruct', :from=>'ruby'

This will load the `ostruct.rb` script from the Ruby standard library regardless
of whether someone else dropped an `ostruct.rb` file in their project's `lib/`
directory without understanding the potential consequences.

### 4.2 GemLoader

The Gem wedge is similar to the Ruby wedge, in that it isolates the loading
of a gem's files from other gems.

    gem 'facets', '~>2.8'

    require 'string/margin', :from=>'facets'

With this we can be sure that 'facets/string/margin' was loaded from the Facets
library regardless of whether some other gem has a 'facets/string/margin' file
in its `lib/` directory. If no gem has this file, it will fallback to the 
remaining loaders. However, if we use the `:gem` options instead, it will 
raise a load error.

    require 'string/does_not_exit', :gem=>'facets'

The Gem wedge also supports version constraints, so you do not have to use 
`gem()` method for one off requires from a given gem.

    require 'string/margin', :from=>'facets', :version=>'~>2.8'

### 4.3 VendorLoader

The Vendor wedge is used to add vendored projects to the load system.
This is especially useful for development. Vendored projects can be added
in two ways, by registering an instance of VendorLoader, e.g.

    Loadable.register Loadable::VendorLoader.new('vendor/*')

Or using the dedicated `Loadable.vendor(*dir)` method that Loadable provides
to make this more convenient.

    Loadable.vendor('vendor/*')


## 5 Development

Source code for Loadbable is hosted by [GitHub](http://github.com/rubyworks/loadable).

If you has come across and issues, we encourage you to fork the repository and 
submit a pull request with the fix. When submitting a pull request, it is best
if the changes are orgnanized into a new topic branch.

If you don't have time to code up patches yourself, please do not hesitate to
simply report the issue on the [issue tracker](http://github.com/rubyworks/loadable/issues).


## 6 Copyrights

Copyright (c) 2010 Thomas Sawyer, Rubyworks

Load is distributed under the terms of the **FreeBSD** license.

See COPYING.rdoc file for details.

