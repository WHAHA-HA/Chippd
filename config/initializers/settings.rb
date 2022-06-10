configatron.application.name = 'Chipp&#8217;d'

configatron.crushlovely_url = 'http://crushlovely.com'
configatron.email_addresses.do_not_reply = 'do-not-reply@chippd.com'
configatron.email_addresses.notification = %w(ship@chippd.com omar@chippd.com)
configatron.email_addresses.exceptions = %w(omar@chippd.com admin@crushlovely.com)
configatron.date_formats.short = '12/31/99'
configatron.date_formats.long = 'July 4, 2012'
configatron.date_formats.db = '2011-05-15'
configatron.date_formats.invoice = 'Saturday, October 6, 2012'
configatron.time_formats.twelve_hour = '08:30 PM'
configatron.time_formats.twenty_four_hour = '19:00'
configatron.datetime_formats.default = 'July 1, 2009 3:00pm'
configatron.default_currency = Money::Currency.new(Money.default_currency.iso_code)
configatron.sales_tax_rate = 0.08875
configatron.alphanumeric_regex = /^[a-zA-Z0-9.-\/]+$/
configatron.email_regex = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/
configatron.select_data.iconable_kinds = [:portfolio, :resume, :other]
configatron.select_data.us_states = YAML.load_file(File.join(Rails.root, "config", "us_states.yml"))

configatron.example_pages = {
  :love     => '5075a17554ec9c000200000d',
  # :flock    => '5075a59454ec9c0002000039',
  :flock    => '51812d661f44580002000033', #new flock
  :party    => '5075a59454ec9c0002000039', #old flock
  :story    => '5075a59754ec9c000200003b',
  :showcase => '5075a59a54ec9c000200003d',
  :mom1 => '51812b2c1f44580002000013',
  :mom2 => '51812c6a1f44580002000023',
  :mom3 => '51812d661f44580002000033',
  :mom4 => '51812ddd1f44580002000043',
  :mom5 => '51812e581f44580002000053',
  :mom6 => '51818f3a1f445800020000d2',
  :mom7 => '5181955c1f445800020000e6',
  :for_mom => '51899fc39721a60002000047',
  :baby => '53758ec0c710acc14e000002',
  :wedding => '5376c12c01f1238391000001'
  #:ebola => '54d274234c06fcc008000001'
}

configatron.pages.widgets = [
  {
    :name => 'Standard',
    :widgets => [
      { :type => :photo          , :name => "Photo" },
      { :type => :video          , :name => "Video" },
      { :type => :gallery        , :name => "Gallery" },
      { :type => :text           , :name => "Text" },
      { :type => :vcard          , :name => "vCard" },
      { :type => :event          , :name => "Event" },
      { :type => :locket         , :name => "Locket" },
      { :type => :playlist       , :name => "Playlist" },
      { :type => :mobile_playlist, :name => "Mobile Playlist" },
      { :type => :social         , :name => "Social" },
      { :type => :link           , :name => "Link" },
      { :type => :pdf            , :name => "Pdf" },
      { :type => :generic_pdf    , :name => "GenericPdf" },
      { :type => :embedded_video , :name => "Embedded Video" },
      { :type => :embedded_audio , :name => "Embedded Audio" },
      { :type => :auction        , :name => "Auction" },
    ]
  },
  {
    :name => 'Wedding',
    :widgets => [
      { :type => :save_the_date         , :name => "Save the Date" },
      { :type => :invitation            , :name => "Invitation" },
      { :type => :rsvp                  , :name => "RSVP" },
      { :type => :the_couple            , :name => "The Couple" },
      { :type => :wedding_party         , :name => "The Wedding Party" },
      { :type => :timeline              , :name => "Timeline" },
      { :type => :wedding_events_widget , :name => "Wedding Events" },
      { :type => :places_to_stay        , :name => "Places to Stay" },
      { :type => :gift_registry         , :name => "Gift Registry" },
      { :type => :engagement            , :name => "Engagement" }
    ]
  },
  {
    :name => 'Baby',
    :widgets => [
      { :type => :about_baby             , :name => "About Baby" },
      { :type => :baby_family            , :name => "Baby's Family" },
      { :type => :before_baby            , :name => "Before Baby" },
      { :type => :baby_arrives_widget    , :name => "Baby Arrives" },
      { :type => :baby_grows_widget      , :name => "Baby Grows" },
      { :type => :babys_first            , :name => "Baby's First" },
      { :type => :babys_favorites_widget , :name => "Baby's Favorites" }
    ]
  }
]

configatron.pages.valid_section_types = configatron.pages.widgets.collect { |g| g[:widgets].collect { |w| w[:type] } }.flatten
configatron.pages.long_page_navigation_threshold = 5

configatron.character_limits = Hashie::Mash.new({
  :event => {
    :title => 70,
    :description => 140,
    :url => 40
  },
  :link => {
    :title => 70
  },
  :pdf => {
    :title => 70
  },
  :invitation => {
    :intro => 24,
    :location_name => 40,
    :after => 96,
    :note => 170,
    :bride_name => 80,
    :groom_name => 80
  },
  :the_couple => {
    :bride_name => 40,
    :bride_bio => 280,
    :bride_parents => 70,
    :groom_name => 40,
    :groom_bio => 280,
    :groom_parents => 70
  },
  :about_baby => {
    :weight => 13,
    :height => 13
  },
  :baby_arrives => {
    :first_name => 40,
    :last_name => 40,
    :hospital => 40,
    :parents => 50,
    :weight => 13,
    :height => 13
  },
  :baby_family => {
    :father_name => 50,
    :father_bio => 180,
    :mother_name => 50,
    :mother_bio => 180
  },
  :rsvp => {
    :heading => 28,
    :yes_text => 21,
    :no_text => 21,
    :thank_you_message => 300,
    :date_past_message => 300
  },
  :embedded_video => {
    :caption => 70
  },
  :timeline => {
    :timeframe => 70,
    :heading => 70,
    :description => 140
  },
  :gift_registry => {
    :name => 25,
    :url => 32
  }
})
