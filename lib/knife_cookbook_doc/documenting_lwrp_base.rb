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

    def property(name, type = ::Chef::NOT_PASSED, **options)
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
