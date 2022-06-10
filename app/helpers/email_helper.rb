module EmailHelper
  def base_url
    root_url(:protocol => ((Rails.env.production? || Rails.env.staging?) ? 'https' : 'http'))
  end
end