module TokenGenerator
  extend ActiveSupport::Concern

  def generate_token
    loop do
      key = SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')
      break key unless self.class.find_by(token: key)
    end
  end
end