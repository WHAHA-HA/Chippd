class Api::V1::PagesPresenter < Api::V1::BasePresenter
  def as_json(options = {})
    {
      :pages => hashes_for(@object)
    }
  end

  protected

  def hashes_for(collection)
    result = []
    collection.each do |item|
      result << hash_for(item)
    end
    result
  end

  def hash_for(item)
    {
      :name => item.page.name,
      :key => item.key,
      :privacy => item.privacy.to_sym,
      :recently_updated => is_recently_updated?(item)
    }
  end

  def is_recently_updated?(item)
    item.last_viewed_at ? (item.last_viewed_at < item.page.updated_at) : true
  end
end
