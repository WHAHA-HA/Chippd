module TranscodingSupport
  extend Memoist

  ADVANCED_SMARTPHONE_PRESET_ID  = '1397766036546-dt7vyr'
  UNIVERSAL_SMARTPHONE_PRESET_ID = '1397765536833-k20mtr'
  WEBM_PRESET_ID = '1397774863559-peyvo1'
  HLS_PRESET_ID  = '1351620000001-200030'
  MP3_PRESET_ID = '1397775223808-m8c19g'

  def transcoder_client
    @transcoder_client ||= AWS::ElasticTranscoder::Client.new(region: configatron.amazon.region)
  end

  def input_key(url)
    URI.parse(url).path.sub(/\/#{configatron.s3.upload_bucket_name}\//, '')
  end
  memoize :input_key

  def directory(url)
    Pathname.new(input_key(url)).dirname.to_s + '/'
  end
  memoize :directory

  def filename(url)
    Pathname.new(input_key(url)).basename('.*').to_s
  end
  memoize :filename

  def advanced_smartphone(url)
    {
      key: "#{filename(url)}_adv.mp4",
      preset_id: ADVANCED_SMARTPHONE_PRESET_ID,
      thumbnail_pattern: "#{filename(url)}_{count}"
    }
  end

  def universal_smartphone(url)
    {
      key: "#{filename(url)}_uni.mp4",
      preset_id: UNIVERSAL_SMARTPHONE_PRESET_ID,
      thumbnail_pattern: "#{filename(url)}_{count}"
    }
  end

  def webm(url)
    {
      key: "#{filename(url)}.webm",
      preset_id: WEBM_PRESET_ID,
      thumbnail_pattern: "#{filename(url)}_{count}"
    }
  end

  def hls(url)
    {
      key: "#{filename(url)}.hls",
      preset_id: HLS_PRESET_ID,
      thumbnail_pattern: "#{filename(url)}_{count}"
    }
  end

  def mp3(url)
    {
      key: "#{filename(url)}.mp3",
      preset_id: MP3_PRESET_ID
    }
  end

  def create_audio_job(url)
    options = {
      pipeline_id: configatron.amazon.pipeline_id,
      input: { key: input_key(url) },
      output_key_prefix: directory(url),
      outputs: [ mp3(url) ]
    }
    transcoder_client.create_job(options)
  end

  def create_video_job(url)
    options = {
      pipeline_id: configatron.amazon.pipeline_id,
      input: { key: input_key(url) },
      output_key_prefix: directory(url),
      outputs: [ advanced_smartphone(url), universal_smartphone(url), webm(url), hls(url) ]
    }
    transcoder_client.create_job(options)
  end

end
