class FaqPresenter < BasePresenter
  presents :faq
  delegate :question, :to => :faq
  delegate :to_key, :to => :faq

  def self.model_name
    Faq.model_name
  end

  def answer
    markdown(faq.answer)
  end
end