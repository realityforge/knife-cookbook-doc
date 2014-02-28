module KnifeCookbookDoc
  class RecipeModel
    include KnifeCookbookDoc::BaseModel

    attr_reader :name
    attr_reader :short_description

    def initialize(name, short_description = nil, filename)
      @name = name
      @short_description = short_description
      @filename = filename
      load_descriptions
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
  end
end
