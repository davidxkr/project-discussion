require 'rails_helper'

describe UserAuthenticator do
  let(:user) { create(:user) }
  let(:remote_ip) { '127.0.0.1' } 

  describe '#authenticate_user' do

    def authenticate_user(user, password)
      UserAuthenticator.authenticate_user( user: user,
                                           password: password,
                                           remote_ip: remote_ip )
    end

    context 'invalid user credentials' do

      it 'expect an error on email ' do
        user_result = authenticate_user(nil, '1234')

        expect(user_result.errors).to have_key(:email)
      end

      it 'expect an error on password' do
        user_result = authenticate_user(user, '1234')

        expect(user_result.errors).to have_key(:password)
      end

      it 'expect an error on blocked' do
        user_blocked = create(:user, blocked: true)
        user_result = authenticate_user(user_blocked, '123456')

        expect(user_result.errors).to have_key(:blocked)
      end

      it 'should return nil on session' do
        user_result = authenticate_user(user, '1234')

        expect(user_result.session).to be nil
      end
    end

    context 'with valid user credentials' do
      let(:user_with_session) { authenticate_user(user, '123456') }

      it { expect(user_with_session).to be_valid }

      it { expect(user_with_session.session).to be_a(Session) }

      it { expect(user_with_session.session_token).not_to be_empty}
    end
  end
end