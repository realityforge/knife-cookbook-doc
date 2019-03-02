module KnifeCookbookDoc
  class ResourceModel
    include KnifeCookbookDoc::BaseModel

    attr_reader :native_resource

    def initialize(cookbook_name, file)
      @native_resource = build_native_from_file(cookbook_name, file)
      load_descriptions
    end

    def name
      @native_resource.resource_name
    end

    # Return the unique set of actions, with the default one first, if there is a single default
    # The :nothing action will show up only if it is the only one, or it is  explicitly  documented
    def actions
      return @actions unless @actions.nil?

      if default_action.is_a?(Array)
        @actions = @native_resource.actions
      else
        @actions = [default_action].compact + @native_resource.actions.sort.uniq.select { |a| a != default_action }
      end

      @actions.delete(:nothing) if @actions != [:nothing] && action_descriptions[:nothing].nil?
      @actions
    end

    def default_action
      action = @native_resource.default_action
      return action.first if action.is_a?(Array) && action.length == 1
      action
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
      specification && specification.key?(:default)
    end

    def attribute_default_value(attribute)
      default = if attribute_has_default_value?(attribute)
                  @native_resource.attribute_specifications[attribute][:default]
                end

      if default.is_a?(Chef::DelayedEvaluator)
        'lazy { ... }'
      else
        default.inspect
      end
    end

    def attribute_descriptions
      @attribute_descriptions ||= {}
    end

    private

    def load_descriptions
      current_section = 'main'
      @native_resource.description.each_line do |line|
        if /^ *\@action *([^ ]*) (.*)$/ =~ line
          action_descriptions[$1] = $2.strip
        elsif /^ *(?:\@attribute|\@property) *([^ ]*) (.*)$/ =~ line
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
