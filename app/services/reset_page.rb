class ResetPage
  attr_reader :page

  def self.call(page_id)
    new(page_id).call
  end

  def initialize(page_id)
    @page = Page.find(page_id)
  end

  def call
    page.sections.each do |section|
      DestroySectionWorker.perform_async(section.to_param)
    end
  end
end