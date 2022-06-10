# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://chippd.com"

SitemapGenerator::Sitemap.create do
  # Index gets added by default
  add store_root_path
  add about_us_path
  add how_it_works_path
  add contact_us_path
  add newsletter_path

  # It is technically not valid to add a link to another host, but Google may
  # use or just ignore this link.
  #
  add '/blog', :host => 'http://chippd.tumblr.com', :priority => 0.75
  add press_releases_path, :priority => 0.75
end