class Admin
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable, :trackable, :validatable


  ## Database authenticatable
  field :email,              :type => String
  field :encrypted_password, :type => String

  ## Trackable
  field :sign_in_count,      :type => Integer
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  field :level, :type => Symbol, :default => :admin

  def is?(_level)
    level == _level
  end
end
