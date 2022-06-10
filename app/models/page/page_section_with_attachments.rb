class PageSectionWithAttachments < PageSection
  include AttachmentField

  field :state, :type => Symbol, :default => :pending

  def pend!
    self.state = :pending
    self.save!
  end

  def activate!
    self.state = :active
    self.save!
  end

  def error!
    self.state = :error
    self.save!
  end

  def pending?
    self.state == :pending
  end

  def active?
    self.state == :active
  end

  def error?
    self.state == :error
  end

  def upload_enabled?
    true
  end

  def uses_storage?
    true
  end
end
