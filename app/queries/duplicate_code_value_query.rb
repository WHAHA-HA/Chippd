class DuplicateCodeValueQuery
  def self.call(codes)
    new(codes).call
  end

  def initialize(codes)
    @codes = codes
  end

  def call
    Code.in(query_attr => @codes).to_a.collect(&query_attr)
  end

  protected

  def query_attr
    :value
  end
end