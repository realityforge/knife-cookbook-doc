module KnifeCookbookDoc
  class DefinitionsModel
    include KnifeCookbookDoc::BaseModel
    attr_reader :name

    def initialize(name, filename)
      @name = name
      @filename = filename
      load_descriptions
    end

    def params
      @params ||= {}
    end

    private

    def load_descriptions
      description = extract_description
      current_section = 'main'
      description.each_line do |line|
        if /^ *\@param *([^ ]*) (.*)$/ =~ line
          params[$1] = $2.strip
        elsif /^ *\@section (.*)$/ =~ line
          current_section = $1.strip
        else
          lines = (top_level_descriptions[current_section] || [])
          lines << line.gsub("\n",'')
          top_level_descriptions[current_section] = lines
        end
      end
    end
  end
end

