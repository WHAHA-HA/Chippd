class Api::V1::BasePresenter
  def initialize(object)
    @object = object
  end

  def as_json(options = {})    
    raise Chippd::ImplementInSubclassError
  end

  protected

  def object
    @object
  end
end
