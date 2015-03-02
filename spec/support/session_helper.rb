module SessionHelper
  def create_session_for_user(user = nil)
  	user = build(:user) if user.nil?
  	create_session(user)
    user
  end

  def create_session(user)
    session = build(:session)
    session.set_token
    user.session = session
    user.save
  end
end