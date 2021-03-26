begin
  require 'berkshelf'
rescue LoadError
  # won't be able to get :source_url for dependent cookbooks
end

module KnifeCookbookDoc
  class ReadmeModel
    DEFAULT_CONSTRAINT = ">= 0.0.0".freeze

    attr_reader :libraries

    def initialize(cookbook_dir, config)

      @metadata = Chef::Cookbook::Metadata.new
      @metadata.from_file("#{cookbook_dir}/metadata.rb")

      if (!@metadata.attributes.empty? rescue false)
        @attributes = @metadata.attributes.map do |attr, options|
          name = "node['#{attr.gsub("/", "']['")}']"
          [name, options['description'], options['default'], options['choice']]
        end
      else
        @attributes = []
        Dir["#{cookbook_dir}/attributes/*.rb"].sort.each do |attribute_filename|
          model = AttributesModel.new(attribute_filename, config)
          if !model.attributes.empty?
            @attributes += model.attributes
          end
        end
      end

      @libraries = Dir["#{cookbook_dir}/libraries/*.rb"].sort.map do |path|
        LibrariesModel.new(@metadata.name, path)
      end

      @resources = []
      Dir["#{cookbook_dir}/resources/*.rb"].sort.each do |resource_filename|
        @resources << ResourceModel.new(@metadata.name, resource_filename)
      end

      @definitions = []
      Dir["#{cookbook_dir}/definitions/*.rb"].sort.each do |def_filename|
        @definitions << DefinitionsModel.new(File.basename(def_filename, '.*'), def_filename)
      end

      @fragments = {}
      Dir["#{cookbook_dir}/doc/*.md"].sort.each do |resource_filename|
        @fragments[::File.basename(resource_filename,'.md')] = IO.read(resource_filename)
      end

      @recipes = []
      if !@metadata.recipes.empty?
        @metadata.recipes.each do |name, description|
          @recipes << RecipeModel.new(name, description, "#{cookbook_dir}/recipes/#{name.gsub(/^.*\:(.*)$/,'\1')}.rb")
        end
      else
        Dir["#{cookbook_dir}/recipes/*.rb"].sort.each do |recipe_filename|
          base_name = File.basename(recipe_filename, ".rb")
          if !base_name.start_with?("_")
            @recipes << RecipeModel.new("#{@metadata.name}::#{base_name}", recipe_filename)
          end
        end
      end
      @metadata = @metadata
      @constraints = config[:constraints]
    end

    def fragments
      @fragments
    end

    def resources
      @resources
    end

    def definitions
      @definitions
    end

    def cookbook_name
      @metadata.name
    end

    def description
      @metadata.description
    end

    def source_url
      if @metadata.methods.include? :source_url
        @metadata.source_url
      else
        ""
      end
    end

    def issues_url
      if @metadata.methods.include? :issues_url
        @metadata.issues_url
      else
        ""
      end
    end

    def platforms
      @metadata.platforms.map do |platform, version|
        format_constraint(platform, version)
      end
    end

    def chef_versions
      if @metadata.methods.include?(:chef_version)
        @metadata.chef_versions.map do |chef_version|
          constraints = chef_version.requirements_list.join(', ')
          format_constraint(chef_version.name, constraints)
        end
      else
        []
      end
    end

    def dependencies
      @metadata.dependencies.map do |cookbook, version|
        format_constraint(cookbook, version)
      end
    end

    def recommendations
      if @metadata.methods.include?(:recommendations)
        @metadata.recommendations.map do |cookbook, version|
          format_constraint(cookbook, version)
        end
      else
        []
      end
    end

    def suggestions
      if @metadata.methods.include?(:suggestions)
        @metadata.suggestions.map do |cookbook, version|
          format_constraint(cookbook, version)
        end
      else
        []
      end
    end

    def conflicting
      if @metadata.methods.include?(:conflicting)
        @metadata.conflicting.map do |cookbook, version|
          format_constraint(cookbook, version)
        end
      else
        []
      end
    end

    def attributes
      @attributes
    end

    def recipes
      @recipes
    end

    def maintainer
      @metadata.maintainer
    end

    def maintainer_email
      @metadata.maintainer_email
    end

    def license
      @metadata.license
    end

    def name
      @metadata.name
    end

    def get_binding
      binding
    end

    private

    def source_url_from_berkshelf(name)
      @source_url ||= begin
        if File.exist?('Berksfile') && defined?(::Berkshelf)
          ::Berkshelf::Berksfile
            .from_file('Berksfile')
            .install
            .map { |cb| [cb.cookbook_name, cb.metadata.source_url] }
            .to_h
        else
          {}
        end
      end
      @source_url[name]
    end

    def format_constraint(name, version)
      url = source_url_from_berkshelf(name)
      if !url.nil? && url.start_with?('http')
        # git:// and ssh:// URLs are not browsable
        name = "[#{name}](#{url})"
      end

      if @constraints && version != DEFAULT_CONSTRAINT
        "#{name} (#{version})"
      else
        name
      end
    end
  end
end
