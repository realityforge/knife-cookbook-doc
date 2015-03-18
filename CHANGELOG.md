# v0.14.0 (Mar 17 2015)

* Further bug-fixes for multi-line attributes. Submitted By Drew Blessing.
* Fix the default values emitted in documentation.

# v0.13.0 (Mar 17 2015)

* Fix get_attribute_name to use the newly supplied precedent level. Submitted By Drew Blessing.
* Further refinements for multi-line attributes. Submitted By Drew Blessing.

# v0.12.0 (Mar 17 2015)

* Improve regex that matches attributes to support all 5 precedent
  specifiers and also supports multiline definitions. This is backwards
  compatible. Submitted By Drew Blessing.

# v0.11.0  (Jun 5 2014)

* Be honest about attribute types. Submitted by benlangfeld.

# v0.10.0  (Mar 3 2014)

* Add support for generating documentation for definitions. Submitted by zhelyan.
* Remove end of line whitespace in generated README

# v0.9.0 (Feb 24 2014)

* Convert cookbook_dir to real path to ensure the plugin works in alternative shells such as powershell. Submitted by zhelyan.

# v0.8.0 (Feb 14 2014)

* Fix compatibility with Chef 11.8.0. Submitted by Ben Langfeld.

# v0.7.0 (Oct 13 2013)

* Add some basic documentation regarding scanning documentation for attributes.

# v0.6.0 (Oct 7 2013)

* Fix bug in attributes model due to incorrectly named method call. Reported by Jared Russell.

# v0.5.0 (Sep 16 2013)

* Re-push gem with correct set of changes to rubygems.

# v0.4.0 (Sep 16 2013)

* Scan the recipes directory for recipes if no recipes are declared in the metadata.rb (Skipping recipes with a name starting with '_'). Submitted by Jarek Gawor.
* Scan the attributes files if no attributes are declared in the metadata.rb and collect descriptions from comments. Submitted by Jarek Gawor.
* Descriptions scanned from source files should expect the . separator to be followed by a space. Submitted by Jarek Gawor.

# v0.3.0 (Apr 1 2013)

* Replace the last section of the readme with the doc/credit.md fragment if it is present.

# v0.2.0 (Apr 1 2013)

* Rework plugin to generate documentation for LWRPs.
* Update the plugin to scan the source file for annotations to add to README.

# v0.1.1 (Feb 20 2013)

* Convert plugin into a gem that can be installed via RubyGems.
* Update README.
* Add this CHANGELOG file.

# v0.1.0 (Dec 5 2012)

* First tagged version.
