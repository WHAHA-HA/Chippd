class ContentPresenter < BasePresenter
  presents :content
  delegate :name, :to => :content
  delegate :content_locations, :to => :content

  def body
    markdown(content.body)
  end

  def location_information
    markdown("This content is displayed on the #{content.content_locations.collect { |l| "[#{l.name}](#{l.path})"}.to_sentence} #{'page'.pluralize(content.content_locations.length)}")
  end

  def short_location_information
    markdown(content.content_locations.collect { |l| "[#{l.name}](#{l.path})" }.to_sentence)
  end
end