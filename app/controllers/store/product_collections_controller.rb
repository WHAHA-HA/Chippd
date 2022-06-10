class Store::ProductCollectionsController < Store::BaseController
  def index
    @product_collections = ProductCollectionPresenter.from_collection(ProductCollection.visible, view_context)
  end
end
