class UserSerializer < ActiveModel::Serializer
  attributes :email, :token, :name

  def token
  	object.session_token
  end
end