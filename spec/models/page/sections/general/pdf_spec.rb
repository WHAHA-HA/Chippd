require 'spec_helper'

describe Pdf do
  it { should be_a(GenericPdf) }
  it { should be_iconable }
end