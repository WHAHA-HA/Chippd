class ApiConstraint
  def self.matches?(request)
    request.subdomain.include?("api")
  end
end
