module KnifeCookbookDoc
  class LibrariesModel
    include KnifeCookbookDoc::BaseModel

    attr_reader :descriptions

    def initialize(name, filename)
      @name = name
      @filename = filename
      @descriptions = extract_description
    end
  end
end
