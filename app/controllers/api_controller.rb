class ApiController < ActionController::Base
  before_action :authenticate_application!

  respond_to :json

  protected
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