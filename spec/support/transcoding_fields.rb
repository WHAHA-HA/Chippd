RSpec::Matchers.define :have_transcoding_fields do
  match do
    subject.should have_field("job_id").of_type(String)
  end
end
