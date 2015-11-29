#<
# This resource is awesome.
#>

#<> @attribute my_attribute This is an attribute.
attribute :my_attribute, default: 'a default value'

#<> @property my_property This is a property.
property :my_property, default: 'another default value'

default_action :stuff

#<> @action stuff Does awesome things.
action :stuff do
  # awesome things
end
