class UserAuthenticator
  attr_reader :user, :password, :remote_ip

  def initialize(params)
    @user = params[:user]
    @password = params[:password]
    @remote_ip = params[:remote_ip]
  end

  class << self
    def authenticate_user(params)
      authenticator = self.new(params)
      authenticator.authenticate_user
    end
  end

  def authenticate_user
    @user ||= User.new
    authenticate
    user
  end

  def authenticate
    authenticated = false
    set_error_on_new unless user.persisted?

    set_error_on_blocked_user if user.blocked?

    authenticated = user.authenticate(password) if user.errors.empty?

    set_error_on_failed_authentication unless authenticated

    set_user_session if authenticated
    authenticated
  end

  private

  def set_error_on_new
    user.add_error(:email, I18n.t('exceptions.user.not_found'))
  end

  def set_error_on_failed_authentication
    user.add_error(:password, I18n.t('exceptions.user.invalid_password'))
  end

  def set_error_on_blocked_user
    user.add_error(:blocked, I18n.t('exceptions.user.blocked'))
  end

  def set_user_session
    user.session = SessionBuilder.build(remote_ip)
    user.save
  end
end