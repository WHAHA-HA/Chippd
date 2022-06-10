class FavoritePresenter < BasePresenter
  presents :favorite
  delegate :category, :title, :to => :favorite

end
