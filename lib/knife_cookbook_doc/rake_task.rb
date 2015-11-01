require 'chef/cookbook/metadata'
require 'erubis'
require 'rake'
require 'rake/tasklib'

require 'knife_cookbook_doc/base_model'
require 'knife_cookbook_doc/documenting_lwrp_base'
require 'knife_cookbook_doc/definitions_model'
require 'knife_cookbook_doc/readme_model'
require 'knife_cookbook_doc/recipe_model'
require 'knife_cookbook_doc/resource_model'
require 'knife_cookbook_doc/attributes_model'

module KnifeCookbookDoc
  class RakeTask < ::Rake::TaskLib
    attr_accessor :name

    def initialize(name = :knife_cookbook_doc)
      @name = name
      @options = {}
      yield self if block_given?
      define
    end

    def define
      desc 'Generate cookbook documentation' unless ::Rake.application.last_comment
      task(name) do
        options = @options.merge(default_options)
        cookbook_dir = File.realpath(options[:cookbook_dir])
        model = ReadmeModel.new(cookbook_dir, options[:constraints])
        template = File.read(options[:template_file])
        eruby = Erubis::Eruby.new(template)
        result = eruby.result(model.get_binding)

        File.open("#{cookbook_dir}/#{options[:output_file]}", 'wb') do |f|
          result.each_line do |line|
            f.write line.gsub(/[ \t\r\n]*$/,'')
            f.write "\n"
          end
        end
      end
    end

    private
    def default_options
      {
        cookbook_dir: './',
        constraints: true,
        output_file: 'README.md',
        template_file: Pathname.new("#{File.dirname(__FILE__)}/../chef/knife/README.md.erb").realpath
      }
    end
  end
end
