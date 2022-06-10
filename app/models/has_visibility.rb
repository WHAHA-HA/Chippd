module HasVisibility
  extend ActiveSupport::Concern

  included do |base|
    base.field :is_visible, :type => Boolean, :default => true
    base.scope :visible, where(:is_visible => true)
    base.scope :hidden, where(:is_visible => false)
  end

  def visible?
    self.is_visible
  end

  def hidden?
    !self.is_visible
  end

  def toggle_visibility!
    self.is_visible = !is_visible
    self.save
  end
end