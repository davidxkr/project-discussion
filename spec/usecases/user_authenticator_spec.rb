require 'rails_helper'

describe UserAuthenticator do
  let(:user) { create(:user) }
  let(:remote_ip) { '127.0.0.1' } 

  describe '#authenticate_user' do
    context 'invalid user credentials' do

      it 'expect an error on email ' do
        user_result = UserAuthenticator.authenticate_user( user: nil,
                                                           password: '12',
                                                           remote_ip: remote_ip )

       expect(user_result.errors).to have_key(:email)
      end

      it 'expect an error on password' do
        user_result = UserAuthenticator.authenticate_user( user: user,
                                                           password: '123',
                                                           remote_ip: remote_ip )
        expect(user_result.errors).to have_key(:password)
      end

      it 'expect an error on blocked' do
        user_blocked = create(:user, blocked: true)
        user_result = UserAuthenticator.authenticate_user( user: user_blocked,
                                                           password: '123456',
                                                           remote_ip: remote_ip )
        expect(user_result.errors).to have_key(:blocked)
      end

      it 'should return nil on session' do
      	user_result = UserAuthenticator.authenticate_user( user: user,
                                                           password: '123',
                                                           remote_ip: remote_ip )
      	expect(user_result.session).to be nil
      end
    end

    context 'with valid user credentials' do
      it 'return a valid user' do
        user_result = UserAuthenticator.authenticate_user( user: user,
                                                           password: '123456',
                                                           remote_ip: remote_ip )

        expect(user_result).to be_valid
      end

      it 'the user should have a session' do
        user_result = UserAuthenticator.authenticate_user( user: user,
                                                           password: '123456',
                                                           remote_ip: remote_ip )
        expect(user_result.session).to be_a(Session)
      end
    end
  end
end