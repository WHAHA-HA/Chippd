configatron.shipping.options = [
  OpenStruct.new(:name => "USPS First Class", :key => :greeting_card, :rate_class => "GreetingCardShippingCalculator", :greeting_card_only? => true),
  OpenStruct.new(:name => "USPS Priority", :key => :ground, :rate_class => "GroundShippingCalculator", :greeting_card_only? => false),
  OpenStruct.new(:name => "UPS 2 Day", :key => :two_day, :rate_class => "TwoDayShippingCalculator", :greeting_card_only? => false),
  OpenStruct.new(:name => "UPS Overnight", :key => :overnight, :rate_class => "OvernightShippingCalculator", :greeting_card_only? => false)
]

shipping_config = YAML.load_file(Rails.root.join('config/shipping.yml'))
ups = shipping_config['ups']
configatron.shipping.vendors.ups = OpenStruct.new(:login => ups['login'], :password => ups['password'], :access_key => ups['access_key'])

configatron.shipping.origin = ActiveMerchant::Shipping::Location.new(:country => 'US', :state => 'NY', :city => 'New York', :zip => '10003')

configatron.shipping.packaging_options = [
  OpenStruct.new(:unit_max => 2, :weight => 3.6, :dimensions => [6, 6, 4]),
  OpenStruct.new(:unit_max => 4, :weight => 4.2, :dimensions => [6, 6, 6]),
  OpenStruct.new(:unit_max => 8, :weight => 6.2, :dimensions => [12, 6, 6]),
  OpenStruct.new(:unit_max => 20, :weight => 11.8, :dimensions => [12, 12, 6])
]

configatron.shipping.weight_per_unit = 1.4

configatron.shipping.test_mode = Rails.env.production? ? false : true
