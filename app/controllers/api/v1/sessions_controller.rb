
class Api::V1::SessionsController < ApiController
  def create
    user = User.find_by(email: user_params[:email])
    user = UserAuthenticator.authenticate_user( user: user,
    	                                        password: user_params[:password],
    	                                        request: request )

    respond_with user, location: :api_signin
  end

  def user_params
    params.permit(:email, :password)
  end
end