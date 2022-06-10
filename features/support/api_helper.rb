module ApiHelper
  # Rack-Test expects the app method to return a Rack application
  def api
    if @api
      @api
    else
      Capybara.session_name = :api
      Capybara.default_host = 'api.chippd.local'
      Capybara.app_host = 'http://api.chippd.local'
      @api = Capybara::RackTest::Driver.new(Chippd::Application, :headers => access_headers)
    end
  end

  def parsed_json(json)
    Yajl::Parser.parse(json)
  end

  def access_headers
    @access_headers ||= {}
  end

  def grant_application_access!
    access_headers['X-Application-Token'] = MobileAuthenticator.application_keys[:ios]
  end

  def grant_customer_access!
    access_headers['X-Account-Token'] = current_customer.authentication_token
  end

  def current_customer
    @current_customer ||= FactoryGirl.create(:customer)
  end
end

World(Rack::Test::Methods, ApiHelper)
