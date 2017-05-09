# knife-cookbook-doc

[![Build Status](http://img.shields.io/travis/realityforge/knife-cookbook-doc.svg)](https://travis-ci.org/realityforge/knife-cookbook-doc)
[![Code Climate](https://codeclimate.com/github/realityforge/knife-cookbook-doc/badges/gpa.svg)](https://codeclimate.com/github/realityforge/knife-cookbook-doc)
[![Gem Version](https://badge.fury.io/rb/knife-cookbook-doc.svg)](http://badge.fury.io/rb/knife-cookbook-doc)
[![Dependency Status](https://gemnasium.com/realityforge/knife-cookbook-doc.svg)](https://gemnasium.com/realityforge/knife-cookbook-doc)
[![Inline docs](http://inch-ci.org/github/realityforge/knife-cookbook-doc.svg)](http://inch-ci.org/github/realityforge/knife-cookbook-doc)


This is a knife plugin to help create and maintain a README.md for a cookbook.
As much as possible the plugin makes use of the same metadata as used by chef
when generating the documentation. The plugin will also scan the source files
for annotations present in comments. Users can also add fragments of markdown
into the doc/ directory to merge into the generated README.md file.

The goal is to keep the code as the authoritative source of information. The
hope is that keeping the documentation close to the code will help to maintain
it's currency.

## Getting Started

#### Step 1

Populate the `metadata.rb` of your cookbook according to Opscode's
[documentation](https://docs.chef.io/config_rb_metadata.html). Particular
attention should be paid to documenting the platform compatibility and
cookbook requirements (i.e. depends, recommends, suggests etc). Documentation
for attributes and recipes can either be derived from scanning the source
code or by explicit declaration in `metadata.rb`.

#### Step 2

At the top of each recipe, add a detailed documentation section such as;

    =begin
    #<
    The recipe is awesome. It does thing 1, thing 2 and thing 3!
    #>
    =end

If the user has not specified documentation for the recipe in `metadata.rb`
then the tool takes the first sentence of the detailed documentation as the
summary to use in the table of contents.

#### Step 3

If the user has not specified documentation for the attributes in `metadata.rb`
then the tool scans the attribute files and uses the documentation block
preceding the attribute.

    #<> MyApp Admin Group: The group allowed to manage MyApp.
    default['myapp']['group'] = 'myapp-admin'

#### Step 4

In each LWRP, add detailed documentation such as;

    =begin
    #<
    This creates and destroy the awesome service.

    @action create  Create the awesome service.
    @action destroy Destroy the awesome service.

    @section Examples

        # An example of my awesome service
        mycookbook_awesome_service "my_service" do
          port 80
        end
    #>
    =end

    ...

    #<> @attribute port The port on which the HTTP service will bind.
    attribute :port, :kind_of => Integer, :default => 8080

It should be noted that the documentation of the LWRP requires that the user
document the actions, using `@action <action> <description>` and the attributes
using `@attribute <attribute> <description>`. This allows meaningful
descriptions for the actions and attributes to be added to the README.

The other text will be added at the start of the LWRP documentation
except if marked with `@section <heading>`, in which case it will be added
to the end of the LWRP documentation.

Starting with Chef >12.5, properties will replace attributes in custom
resources. For compatibility, `@property` may be used interchangibly with
`@attribute`. Both will be handled completely identical by the plugin.

#### Step 5

In each definition add documentation like:

      =begin
        #<
        This definition does something useful.

        @param user User to run as.
        @param group User group to run as.

        @section Examples

            # An example of my awesome definition
            mycookbook_awesome_definition "app resources" do
              user 'appuser'
              group 'appgroup'
            end
        #>
      =end


#### Step 6

Finally the user should add some documentation fragments into the `doc/` dir.
Most importantly you should add `doc/overview.md` which will replace the first
`Description` section of the readme. You should also add a `doc/credit.md` which
will replace the last 'License and Maintainer' section in the readme. Under `Requirements` 
section in readme file, `platform` and `cookbooks` are rendered from metadata.rb but if you need to place
anything else like environemnt or databags, you need to create `doc/requirements.md` which will 
add the content to `Requirements` section. The remaining fragments will be included at the end 
of the readme in lexicographic order of the filename.

## Installation

You can install the plugin via RubyGems:

    $ gem install knife-cookbook-doc

Alternatively, you can install the plugin from source:

    $ git clone git://github.com/realityforge/knife-cookbook-doc.git
    $ cd knife-cookbook-doc/
    $ bundle install
    $ bundle exec rake install

Afterwards, the new knife command `knife cookbook doc DIR` will be available.

## Usage

    knife cookbook doc COOKBOOK_DIR (options)

        -o, --output-file FILE           Set the output file to render to relative to cookbook dir. Defaults to README.md
        -t, --template FILE              Set template file used to render README.md

    Examples:

        knife cookbook doc path/to/cookbook
        knife cookbook doc path/to/cookbook --template README.md.erb

Alternatively, you can execute cookbook doc directly from your Rakefile:

    require 'knife_cookbook_doc/rake_task'

    # With default options
    KnifeCookbookDoc::RakeTask.new(:doc)

    # Example with custom options
    KnifeCookbookDoc::RakeTask.new(:doc) do |t|
      t.options[:cookbook_dir] = './'
      t.options[:constraints] = true
      t.options[:output_file] = 'README.md'
      t.options[:template_file] = "#{File.dirname(__FILE__)}/templates/README.md.erb"
    end

## Further Details

### Documentation in comments

The documentation stored in comments comes in three forms;

#### Single line comments

    #<> This is some documentation

#### Multi-line comments using begin/end

    =begin
    #<
    This is some documentation
    #>
    =end

#### Multi-line comments without using begin/end

    #<
    # This is some documentation
    #>

## Version Testing and Support Matrix

This knife plugin is tested against multiple MRI Ruby versions and multiple
Chef versions. We aim to test against the lastest patch version of each minor
version of Chef Client's knife. See the `.travis.yml` for more complete detail.

```
|   Chef   | MRI Ruby |         |         |
| version  |   2.0    |   2.1   |   2.2   |
|----------|----------|---------|---------|
| master   | perhaps  | perhaps | perhaps |
| 12.4.1   | yes      | yes     | yes     |
| 12.3.0   | yes      | yes     | yes     |
| 12.2.1   | yes      | yes     | yes     |
| 12.1.2   | yes      | yes     | yes     |
| 12.0.3   | yes      | yes     | yes     |
| 11.18.12 | yes      | yes     | yes     |
| 11.16.4  | yes      | yes     | yes     |
| 11.14.6  | yes      | yes     | yes     |
| 11.12.8  | yes      | yes     | yes     |
| 11.10.4  | yes      | yes     | yes     |
| 11.8.2   | yes      | yes     | no      |
| 11.6.2   | yes      | yes     | no      |
| 11.4.4   | yes      | yes     | no      |
| 11.2.0   | yes      | yes     | no      |
| 11.0.0   | yes      | yes     | no      |
```

## Credit

The plugin was originally written by Mathias Lafeldt as a way to create
initial README.md from the metadata.rb. It was subsequently rewritten by
Peter Donald to gather information from the other files within the cookbook.
All credit to Mathias for his wonderful idea. Jarek Gawor has also submitted
several major changes.
