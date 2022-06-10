class WeddingEvent
  include Mongoid::Document
  include Mongoid::Timestamps
  include AttachmentField

  embedded_in :wedding_event_widget, :inverse_of => :events

  field :what,       :type => String
  field :when,       :type => String
  # transition from String to Date occured after production, so new forms will
  # use the happens_on field while existing widgets will still use the when field
  field :happens_on, :type => Date
  field :starts_at,  :type => Time
  field :where,      :type => String
  field :url,        :type => String
  field :note,       :type => String


  validates_presence_of :what, :when
  image_attachment_fields :original, :image, :thumb

  image_accessor :original do
    copy_to(:image){|a| a.thumb('600x') }
    copy_to(:thumb){|a| a.thumb('150x150#') }
  end
  image_accessor :image
  image_accessor :thumb

  # note: validations are handled client side, and then sanity checked
  #       server side in the wedding_events_widget upload handler.
  #       This is necessary because of how the new knockout js models are
  #       submitting the form parameters.

  def formatted_happens_on
    self.happens_on ? self.happens_on.stamp('2013-11-30') : ''
  end

  def formatted_starts_at
    self.starts_at ? self.starts_at.stamp('11:00 PM') : ''
  end

  # Note: we are intentionally not including the storage size
  # of image and thumb to avoid confusion over discrepancies
  # between the file uploaded and the reported space used in the UI.
  def storage_used
    calculate_storage_used_for(:original)
  end
end
