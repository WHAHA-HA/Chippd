class SaveTheDatePresenter < PageSectionPresenter
  delegate :your_name, :fiancee_name, :location, :to => :page_section

  def date
    page_section.happens_on.stamp(configatron.date_formats.long)
  end
end
