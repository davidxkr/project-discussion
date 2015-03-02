class ApiController < ActionController::Base

  skip_before_action :verify_authenticity_token
  before_action :authenticate_application!

  respond_to :json

  def default_serializer_options
    { root: false }
  end

  protected

  def current_user
    @current_user
  end

  def current_user?
    !@current_user.nil?
  end

  def authenticate_user!
    authenticate_user || render_unauthorized('User')
  end

  def authenticate_user
    BearerToken.authenticate_with_http_token(self) do |token, options|
      session_token = Session.find_by(token: token)
      @current_user = session_token.try(:user)
    end
  end

  def authenticate_application!
    authenticate_application || render_unauthorized
  end

  def authenticate_application
    authenticate_with_http_token do |token, options|
      Application.find_by(token: token, enable: true)
    end
  end

  def render_unauthorized(realm = 'Application')
    self.headers['WWW-Authenticate'] = "Token realm='#{realm}'"
    render json: {message: 'Bad credentials'}, status: 401
  end
end