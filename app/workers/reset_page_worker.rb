class ResetPageWorker < PageWorker
  def perform(page_id)
    ResetPage.call(page_id)
  end
end