require 'spec_helper'

describe KnifeCookbookDoc::AttributesModel do
  describe '#load_descriptions' do
    before do
      allow(IO).to receive(:read).with('attributes/default.rb').and_return(attributes)
    end
    let(:attributes) {
<<EOS
#<> Single line comment
default['knife_cookbook_doc']['attr1'] = 'attr1_value'

# <> Another single line comment
default['knife_cookbook_doc']['attr1x'] = 'attr1x_value'

#<
# Multiline comment with single line of text
#>
default['knife_cookbook_doc']['attr2'] = 'attr2_value'

# <
# Another multiline comment with single line of text
# >
default['knife_cookbook_doc']['attr2x'] = 'attr2x_value'

=begin
#<
Multiline begin/end with single line of text
#>
=end
default['knife_cookbook_doc']['attr3'] = 'attr3_value'

=begin
# <
Another multiline begin/end with single line of text
# >
=end
default['knife_cookbook_doc']['attr3x'] = 'attr3x_value'

#<
# Multiline comment with
# multiple lines of text
#>
default['knife_cookbook_doc']['attr4'] = 'attr4_value'

# <
# Another multiline comment with
# multiple lines of text
# >
default['knife_cookbook_doc']['attr4x'] = 'attr4x_value'

=begin
#<
Multiline begin/end with
multiple lines of text
#>
=end
default['knife_cookbook_doc']['attr5'] = 'attr5_value'

=begin
# <
Another multiline begin/end with
multiple lines of text
# >
=end
default['knife_cookbook_doc']['attr5x'] = 'attr5x_value'
EOS
    }
    subject do
      KnifeCookbookDoc::AttributesModel.new('attributes/default.rb', {}).attributes
    end

    it do
      is_expected.to include(
        [
          "node['knife_cookbook_doc']['attr1']",
          'Single line comment',
          'attr1_value',
          []
        ]
      )
    end

    it do
      is_expected.to include(
        [
          "node['knife_cookbook_doc']['attr1x']",
          'Another single line comment',
          'attr1x_value',
          []
        ]
      )
    end

    it do
      is_expected.to include(
        [
          "node['knife_cookbook_doc']['attr2']",
          'Multiline comment with single line of text',
          'attr2_value',
          []
        ]
      )
    end

    it do
      is_expected.to include(
        [
          "node['knife_cookbook_doc']['attr2x']",
          'Another multiline comment with single line of text',
          'attr2x_value',
          []
        ]
      )
    end

    it do
      is_expected.to include(
        [
          "node['knife_cookbook_doc']['attr3']",
          'Multiline begin/end with single line of text',
          'attr3_value',
          []
        ]
      )
    end

    it do
      is_expected.to include(
        [
          "node['knife_cookbook_doc']['attr3x']",
          'Another multiline begin/end with single line of text',
          'attr3x_value',
          []
        ]
      )
    end

    it do
      is_expected.to include(
        [
          "node['knife_cookbook_doc']['attr4']",
          "Multiline comment with\nmultiple lines of text",
          'attr4_value',
          []
        ]
      )
    end

    it do
      is_expected.to include(
        [
          "node['knife_cookbook_doc']['attr4x']",
          "Another multiline comment with\nmultiple lines of text",
          'attr4x_value',
          []
        ]
      )
    end

    it do
      is_expected.to include(
        [
          "node['knife_cookbook_doc']['attr5']",
          "Multiline begin/end with\nmultiple lines of text",
          'attr5_value',
          []
        ]
      )
    end

    it do
      is_expected.to include(
        [
          "node['knife_cookbook_doc']['attr5x']",
          "Another multiline begin/end with\nmultiple lines of text",
          'attr5x_value',
          []
        ]
      )
    end
  end
end
