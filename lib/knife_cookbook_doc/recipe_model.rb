module KnifeCookbookDoc
  class RecipeModel

    attr_reader :name
    attr_reader :short_description

    def initialize(name, short_description = nil, filename)
      @name = name
      @short_description = short_description
      @filename = filename
      load_descriptions
    end

    def top_level_description(section)
      (top_level_descriptions[section.to_s] || []).join("\n").gsub(/\n+$/m,"\n")
    end

    def top_level_descriptions
      @top_level_descriptions ||= {}
    end

    private

    def load_descriptions
      current_section = 'main'
      description = extract_description
      description.each_line do |line|
        if /^ *\@section (.*)$/ =~ line
          current_section = $1.strip
        else
          lines = (top_level_descriptions[current_section] || [])
          lines << line.gsub("\n",'')
          top_level_descriptions[current_section] = lines
        end
      end
      if @short_description.nil? 
        @short_description = first_sentence(description) || ""
      end
    end

    include ::Chef::Mixin::ConvertToClassName

    def extract_description
      description = []
      IO.read(@filename).gsub(/^=begin *\n *\#\<\n(.*?)^ *\#\>\n=end *\n/m) do
        description << $1
        ""
      end.gsub(/^ *\#\<\n(.*?)^ *\#\>\n/m) do
        description << $1.gsub(/^ *\# ?/, '')
        ""
      end.gsub(/^ *\#\<\> (.*?)$/) do
        description << $1
        ""
      end
      description.join("\n")
    end

    def first_sentence(string)
      string.gsub(/^(.*?\.(\z|\s))/m) do |match|
        return $1.gsub("\n",' ').strip
      end
      return nil
    end
  end

  class DocumentingLWRPBase < ::Chef::Resource::LWRPBase

    class << self
      def attribute_specifications
        @attribute_specifications ||= {}
      end

      def desc(description)
        @description = "#{@description}#{description}\n"
      end

      def description
        @description || ""
      end
    end

    def self.attribute(attr_name, validation_opts={})
      result = super(attr_name, validation_opts)
      attribute_specifications[attr_name] = validation_opts
      result
    end
  end
end
