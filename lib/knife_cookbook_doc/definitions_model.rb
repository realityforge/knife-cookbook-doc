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
          params[$1] = {}
          params[$1]['descr'] = $2.strip
        elsif /^ *\@section (.*)$/ =~ line
          current_section = $1.strip
        else
          lines = (top_level_descriptions[current_section] || [])
          lines << line.gsub("\n", '')
          top_level_descriptions[current_section] = lines
        end
      end
      load_properties
    end

    def load_properties
      code = IO.read(@filename)
      code.gsub(/^ *define (.*?) (?=do)/m) do
        all = $1.split(' ', 2)
        @name = all.shift.gsub(/:|,/, '')
        next if all.empty?
        all = eval("{#{all.last}}") rescue {}
        all.each do |k, v|
          p_name = k.to_s
          params[p_name] ||= {}
          params[p_name]['default'] = v.nil? ? v : 'nil'
        end
      end
    end
  end
end
