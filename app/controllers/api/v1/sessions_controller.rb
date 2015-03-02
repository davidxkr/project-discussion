
class Api::V1::SessionsController < ApiController
  before_action :authenticate_user!, only: :destroy

  def create
    user = User.find_by(email: user_params[:email])
    user = UserAuthenticator.authenticate_user( user: user,
                                                password: user_params[:password],
                                                remote_ip: request.remote_ip )

    respond_with user, location: :api_signin
  end

  def destroy
    user_session = current_user.session
    user_session.try(:destroy)

    respond_with user_session
  end

  def user_params
    params.permit(:email, :password)
  end
end