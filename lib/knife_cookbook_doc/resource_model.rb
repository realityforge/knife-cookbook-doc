require 'knife_cookbook_doc/documenting_lwrp_base'

module KnifeCookbookDoc
  class ResourceModel

    attr_reader :native_resource

    def initialize(cookbook_name, file)
      @native_resource = build_native_from_file(cookbook_name, file)
      load_descriptions
    end

    def name
      @native_resource.resource_name
    end

    # Return the unique set of actions, with the default one first, if there is a default
    def actions
      unless @actions
        @actions = [default_action].compact + @native_resource.actions.sort.uniq.select { |a| a != default_action }
      end
      @actions
    end

    def default_action
      @native_resource.default_action
    end

    def action_description(action)
      action_descriptions[action.to_s]
    end

    def action_descriptions
      @action_descriptions ||= {}
    end

    def attributes
      @native_resource.attribute_specifications.keys
    end

    def attribute_description(attribute)
      attribute_descriptions[attribute.to_s]
    end

    def attribute_has_default_value?(attribute)
      specification = @native_resource.attribute_specifications[attribute]
      specification && specification.has_key?(:default)
    end

    def attribute_default_value(attribute)
      if attribute_has_default_value?(attribute)
        return @native_resource.attribute_specifications[attribute][:default]
      else
        return nil
      end
    end

    def attribute_descriptions
      @attribute_descriptions ||= {}
    end

    def short_description
      unless @short_description
        @short_description = first_sentence(top_level_description('main'))
      end
      @short_description
    end

    def first_sentence(string)
      string.gsub(/^(.*?\.(\z|\s))/m) do |match|
        return $1.gsub("\n",' ').strip
      end
      return nil
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
      @native_resource.description.each_line do |line|
        if /^ *\@action *([^ ]*) (.*)$/ =~ line
          action_descriptions[$1] = $2.strip
        elsif /^ *\@attribute *([^ ]*) (.*)$/ =~ line
          attribute_descriptions[$1] = $2.strip
        elsif /^ *\@section (.*)$/ =~ line
          current_section = $1.strip
        else
          lines = (top_level_descriptions[current_section] || [])
          lines << line.gsub("\n",'')
          top_level_descriptions[current_section] = lines
        end
      end
    end

    include ::Chef::Mixin::ConvertToClassName

    def build_native_from_file(cookbook_name, filename)
      resource_class = Class.new(DocumentingLWRPBase)

      resource_class.resource_name = filename_to_qualified_string(cookbook_name, filename)
      resource_class.run_context = nil
      resource_data = IO.read(filename)
      resource_data = resource_data.gsub(/^=begin *\n *\#\<\n(.*?)^ *\#\>\n=end *\n/m) do
        "desc <<DOCO\n#{$1}\nDOCO\n"
      end
      resource_data = resource_data.gsub(/^ *\#\<\n(.*?)^ *\#\>\n/m) do
        "desc <<DOCO\n#{$1.gsub(/^ *\# ?/, '')}\nDOCO\n"
      end
      resource_data = resource_data.gsub(/^ *\#\<\> (.*?)$/) do
        "desc #{$1.inspect}\n"
      end

      resource_class.class_eval(resource_data, filename, 1)

      resource_class
    end
  end
end
