class DestroySectionWorker < PageWorker
  def perform(section_id)
    section = Page.find_and_return_section(section_id)
    section.destroy
  end
end