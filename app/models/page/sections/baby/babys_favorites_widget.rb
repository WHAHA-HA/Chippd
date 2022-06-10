class BabysFavoritesWidget < PageSection
  MINIMUM_NUMBER_OF_FAVORITES = 1
  MAXIMUM_NUMBER_OF_FAVORITES = 10
  embeds_many :favorites, :cascade_callbacks => true

  validates :favorites, :length => {
    :minimum => MINIMUM_NUMBER_OF_FAVORITES,
    :message => "must have at least #{MINIMUM_NUMBER_OF_FAVORITES}."
  }

  def favorites_json
    {
      id: id,
      favorites: favorites
    }.to_json
  end
end
