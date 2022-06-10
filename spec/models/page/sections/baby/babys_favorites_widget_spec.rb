require 'spec_helper'

describe BabysFavoritesWidget do
  it { should be_a(PageSection) }
  it { should embed_many(:favorites).of_type(Favorite) }
end
