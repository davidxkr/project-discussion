require 'rails_helper'

describe UserAuthenticator do
  let(:request) { double(remote_ip: '127.0.0.1') }
  let(:user) { create(:user) }

  describe '#authenticate_user' do
    context 'invalid user credentials' do
      it 'expect an error on email ' do
        user_result = UserAuthenticator.authenticate_user( user: nil,
                                                           password: '12',
                                                           request: request )

       expect(user_result.errors).to have_key(:email)
      end

      it 'expect an error on password' do
        user_result = UserAuthenticator.authenticate_user( user: user,
                                                           password: '123',
                                                           request: request )
        expect(user_result.errors).to have_key(:password)
      end

      it 'expect an error on blocked' do
        user_blocked = create(:user, blocked: true)
        user_result = UserAuthenticator.authenticate_user( user: user_blocked,
                                                           password: '123456',
                                                           request: request )
        expect(user_result.errors).to have_key(:blocked)
      end
    end

    context 'with valid user credentials' do
      it 'return a valid user' do
        user_result = UserAuthenticator.authenticate_user( user: user,
                                                           password: '123456',
                                                           request: request )

        expect(user_result).to be_valid
      end
    end
  end
end