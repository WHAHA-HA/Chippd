class BabyImageProcessor
  def place_on_frame_canvas(temp_object)
    tempfile = new_tempfile
    args = " -gravity center #{temp_object.path} #{Rails.root.join('app/assets/images/baby-image-background.jpg').to_s} #{tempfile.path}"
    full_command = "composite #{args}"
    result = `#{full_command}`
    tempfile
  end

  private

  def new_tempfile(ext=nil)
    tempfile = ext ? Tempfile.new(['dragonfly', ".#{ext}"]) : Tempfile.new('dragonfly')
    tempfile.binmode
    tempfile.close
    tempfile
  end
end
