class Api::V1::ErrorsPresenter < Api::V1::BasePresenter
  def as_json(options = {})    
    {
      :errors => object.as_json
    }
  end
end
