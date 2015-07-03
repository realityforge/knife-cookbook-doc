module KnifeCookbookDoc
  module BaseModel

    def top_level_description(section)
      (top_level_descriptions[section.to_s] || []).join("\n").gsub(/\n+$/m,"\n")
    end

    def top_level_descriptions
      @top_level_descriptions ||= {}
    end

    def short_description
      unless @short_description
        @short_description = first_sentence(top_level_description('main'))
      end
      @short_description
    end

    private

    def first_sentence(string)
      string.gsub(/^(.*?\.(\z|\s))/m) do |match|
        return $1.gsub("\n",' ').strip
      end
      return nil
    end

    def extract_description
      description = []
      IO.read(@filename).gsub(/^=begin *\n *\# ?\<\n(.*?)^ *\# ?\>\n=end *\n/m) do
        description << $1
        ""
      end.gsub(/^ *\# ?\<\n(.*?)^ *\# ?\>\n/m) do
        description << $1.gsub(/^ *\# ?/, '')
        ""
      end.gsub(/^ *\# ?\<\> (.*?)$/) do
        description << $1
        ""
      end
      description.join("\n")
    end

  end
end
