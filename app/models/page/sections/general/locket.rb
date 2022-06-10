class Locket < PageSectionWithAttachments
  field :title, :type => String
  field :body, :type => String

  image_attachment_fields :image_one, :image_two

  image_accessor :image_one do
    after_assign { |a| a.thumb!('300x300#') }
  end

  image_accessor :image_two do
    after_assign { |a| a.thumb!('300x300#') }
  end

  validates_presence_of :title, :body

  def storage_used
    calculate_storage_used_for(:image_one, :image_two)
  end
end
