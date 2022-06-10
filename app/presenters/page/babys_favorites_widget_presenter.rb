class BabysFavoritesWidgetPresenter < PageSectionPresenter

  def favorites
    page_section.favorites.collect { |favorite| FavoritePresenter.new(favorite, @template) }
  end

end
