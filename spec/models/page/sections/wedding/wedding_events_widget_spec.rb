require 'spec_helper'

describe WeddingEventsWidget do
  it { should be_a(PageSection) }
  it { should embed_many(:events).of_type(WeddingEvent) }
end
