module Chippd
  class ChippdError < StandardError
    include Bugsnag::MetaData
  end
  class ImplementInSubclassError < ChippdError; end
  class LineItemOrProductDataRequiredError < ChippdError; end
  class QuantityRequiredError < ChippdError; end
  class UnpackableQuantityError < ChippdError; end
  class SectionNotAvailableError < ChippdError; end
  class AssemblyNotCompletedError < ChippdError; end
  class UploadProcessingError < ChippdError; end
  class PostProcessingError < ChippdError; end
end
