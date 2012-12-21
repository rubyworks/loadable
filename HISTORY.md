# RELEASE HISTORY

## 1.2.1 / 2012-12-21

Long overdo bug fix release. This release fixes a typo in the
rubygems search function.

Changes:

* Fix bug in rubygems search function.


## 1.2.0 / 2011-10-15

This release brings an almost complete rewrite of the API and
a renaming of the project form 'wedge' to 'loadable'. See the
API documentaiton for details.

Changes:

* Rewrite API almost entirely.
* Rename project from 'wedge' to 'loadable'.
* Utilize mixin rather than sublcass for loader classes.
* OriginalLoader handles Ruby's default load mechanism.
* New VendorLoader to support development.


## 1.1.0 / 2011-07-03

The Ruby wedge is no longer automatuically loaded when using
`require "wedge"`. Load it manually loaded with `require "wedge/ruby`".

Changes:

* Ruby wedge is not automatically loaded with wedge library.


## 1.0.0 / 2010-09-03

This release is simply a maintenance release, updating some project metadata.
No functionality has been changed.

Changes:

* Uupdate project metadata to latest POM.


## 1.0.0 / 2010-08-01

Initial release of Wedge, a tool for easily creating custom
load managers.

Changes:

* Happy Brithday!

