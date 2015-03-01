class User < ActiveRecord::Base
  has_secure_password validations: true
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  has_one :session

  def add_error(attribute, message)
    errors.add(attribute, message)
  end
end