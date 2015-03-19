require 'spec_helper'

describe KnifeCookbookDoc::AttributesModel do
  describe '#load_descriptions' do
    before do
      allow(IO)
        .to receive(:read).with('attributes/default.rb').and_return(attributes)
    end
    let(:attributes) {
<<EOS
#<> Single line comment
default['knife_cookbook_doc']['attr1'] = 'attr1_value'

#<
# Multiline comment with single line of text
#>
default['knife_cookbook_doc']['attr2'] = 'attr2_value'

=begin
#<
Multiline begin/end with single line of text
#>
default['knife_cookbook_doc']['attr3'] = 'attr3_value'

#<
# Multiline comment with
multiple lines of text
#>
default['knife_cookbook_doc']['attr4'] = 'attr4_value'

=begin
#<
Multiline begin/end with
multiple lines of text
#>
default['knife_cookbook_doc']['attr5'] = 'attr5_value'
EOS
    }
    subject do
      KnifeCookbookDoc::AttributesModel.new('attributes/default.rb').attributes
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
          "node['knife_cookbook_doc']['attr5']",
          "Multiline begin/end with\nmultiple lines of text",
          'attr5_value',
          []
        ]
      )
    end
  end
end
