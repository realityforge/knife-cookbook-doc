require 'chef/knife'
require 'pathname'

module KnifeCookbookDoc
  class CookbookDoc < Chef::Knife
    deps do
      require 'chef/cookbook/metadata'
      require 'erubis'
      require 'knife_cookbook_doc/readme_model'
      require 'knife_cookbook_doc/recipe_model'
      require 'knife_cookbook_doc/resource_model'
      require 'knife_cookbook_doc/attributes_model'
    end

    banner 'knife cookbook doc DIR (options)'

    option :constraints,
           :short       => '-c',
           :long        => '--constraints',
           :boolean     => true,
           :default     => true,
           :description => 'Include version constraints for platforms and dependencies'

    option :output_file,
           :short       => '-o',
           :long        => '--output-file FILE',
           :default     => 'README.md',
           :description => 'Set the output file to render to relative to cookbook dir. Defaults to README.md'

    option :template_file,
           :short       => '-t',
           :long        => '--template FILE',
           :default     => Pathname.new("#{File.dirname(__FILE__)}/README.md.erb").realpath,
           :description => 'Set template file used to render README.md'

    def run
      unless (cookbook_dir = name_args.first)
        ui.fatal 'Please provide cookbook directory as an argument'
        exit(1)
      end

      model = ReadmeModel.new(cookbook_dir, config[:constraints])

      template = File.read(config[:template_file])
      eruby = Erubis::Eruby.new(template)
      result = eruby.result(model.get_binding)

      File.open("#{cookbook_dir}/#{config[:output_file]}",'wb') do |f|
        f.write result
      end
    end
  end
end
