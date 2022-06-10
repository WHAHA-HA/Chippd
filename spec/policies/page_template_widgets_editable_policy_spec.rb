require 'spec_helper'

describe PageTemplateWidgetsEditablePolicy do
  let(:page_template) { double(:chippd_product_types => [double(:id => 1)]) }
  let(:pages_with_template) { [] }

  before { Page.stub(:in).and_return(pages_with_template) }

  subject { PageTemplateWidgetsEditablePolicy.call(page_template) }

  context 'no pages using template' do
    it { should be_true }
  end

  context 'pages using template' do
    let(:pages_with_template) { [1] }
    it { should be_false }
  end
end
