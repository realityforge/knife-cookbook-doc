require 'chef/resource/lwrp_base'

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

    NOT_PASSED = defined?(::Chef::NOT_PASSED) ? ::Chef::NOT_PASSED : "NOT_PASSED"
    def property(name, type = NOT_PASSED, **options)
      return unless defined?(super)
      result = super(name, type, **options)
      attribute_specifications[name] = options
      result
    end
  end

  def self.attribute(attr_name, validation_opts={})
    result = super(attr_name, validation_opts)
    attribute_specifications[attr_name] = validation_opts
    result
  end
end
