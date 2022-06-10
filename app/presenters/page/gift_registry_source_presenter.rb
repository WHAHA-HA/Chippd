class GiftRegistrySourcePresenter < BasePresenter
  presents :gift_registry_source
  delegate :name, :url, :to => :gift_registry_source

  def base_url
    URI.parse(gift_registry_source.url).host
  end
end
