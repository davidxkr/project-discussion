class SessionBuilder
  attr_reader :session

  def initialize(ip_address)
    @session = Session.new(ip_address: ip_address)
    @session.set_token
  end

  class << self
    def build(remote_ip)
      builder = new(remote_ip)
      builder.session
    end
  end
end