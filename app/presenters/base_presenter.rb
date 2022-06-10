class BasePresenter
  extend ActiveModel::Naming
  delegate :to_param, :to_key, :to => :model

  def self.from_collection(collection, template)
    collection.collect { |c| new(c, template) }
  end

  def initialize(object, template)
    @object = object
    @template = template
  end

  def model
    @object
  end

private

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  def markdown(text)
    @h ||= Redcarpet::Render::HTML.new(:hard_wrap => true)
    @m ||= Redcarpet::Markdown.new(@h, :autolink => true, :space_after_headers => true, :tables => true)
    @m.render(text).html_safe
  end

  def handle_none(*args)
    if args.to_a.all?(&:present?)
      yield
    else
      ''
    end
  end

  def method_missing(*args, &block)
    @template.send(*args, &block)
  end
end