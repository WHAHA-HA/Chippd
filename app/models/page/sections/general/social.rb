class Social < PageSection
  NETWORKS = [
    :twitter,
    :facebook,
    :instagram,
    :linked_in,
    :vimeo,
    :you_tube,
    :dribbble,
    :behance,
    :flickr,
    :google_plus
  ]

  NETWORKS.each do |network|
    field :"#{network}_url", :type => String
    validates :"#{network}_url", :format => { :with => URI::regexp(%w(http https)), :message => "must be a properly formatted URL e.g. http://google.com", :allow_blank => true }
  end
end
