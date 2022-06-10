module Iconable
  extend ActiveSupport::Concern

  included do |base|
    base.field :kind, :type => Symbol
    base.validates :kind, :inclusion =>  { :in => configatron.select_data.iconable_kinds }
  end

  def portfolio?
    self.kind == :portfolio
  end

  def resume?
    self.kind == :resume
  end

  def other?
    self.kind == :other
  end
end