module KnifeCookbookDoc
  class AttributesModel

    ATTRIBUTE_REGEX = "(^\s*(?:default|set|force_default|override|force_override).*?)=\s*\n?\s*(.*?)$".freeze

    def initialize(filename)
      @filename = filename
      @attributes = {}
      load_descriptions
    end

    def attributes
      @attributes.map do |name, options|
        [name, options[:description], options[:default], []]
      end
    end

    private

    def load_descriptions
      resource_data = IO.read(@filename)

      # find all attributes
      resource_data.gsub(/#{ATTRIBUTE_REGEX}/) do
        name = get_attribute_name($1)
        value = $2.strip

        if value.start_with?("{")
          value = "{ ... }"
        elsif  value.start_with?("[")
          value = "[ ... ]"
        else
          value = value.gsub(/\A\"|\A'|\"\Z|'\Z/, '')
        end

        options = {}
        options[:default] = value
        @attributes[name] = options
      end

      # get/parse comments
      resource_data = resource_data.gsub(/^=begin\s*\n\s*\#\<\s*\n(.*?)^\s*\#\>\n=end\s*\n#{ATTRIBUTE_REGEX}/m) do
        update_attribute($2, $1)
      end
      resource_data = resource_data.gsub(/^\s*\#\<\n(.*?)^\s*\#\>\n#{ATTRIBUTE_REGEX}/m) do
        update_attribute($2, $1.gsub(/^\s*\# ?/, ''))
      end
      resource_data = resource_data.gsub(/^\s*\#\<\>\s(.*?$)\n#{ATTRIBUTE_REGEX}/) do
        update_attribute($2, $1)
      end
    end

    def update_attribute(name, description)
      name = get_attribute_name(name)
      options = @attributes[name]
      options[:description] = description.strip
    end

    def get_attribute_name(name)
      name.strip.gsub(/^(default|set|force_default|override|force_override)/, "node")
    end

  end
end
