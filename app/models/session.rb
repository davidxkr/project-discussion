class Session < ActiveRecord::Base
  include TokenGenerator

  validates :token, :ip_address, presence: true

  belongs_to :user

  def set_token
    self.token = generate_token if token.blank?
  end
end
