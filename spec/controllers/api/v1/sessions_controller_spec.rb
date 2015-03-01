require 'rails_helper'

describe Api::V1::SessionsController do

  before(:each){ include_default_accept_headers }

  let(:user) { create(:user) }

  let(:session_params) {
    {email: user.email, password: '123456'}
  }

  context 'invalid login' do
    it 'should deny login when email is not found' do
      custom_params = session_params.clone
      custom_params[:email] = 'demo@email.com'

      post :create, custom_params

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'should deny login when password is invalid' do
      custom_params = session_params.clone
      custom_params[:password] = 'demo'

      post :create, custom_params

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'should deny login when the user is blocked' do
      user_blocked = create(:user, blocked: true)

      post :create, {email: user_blocked.email, password: '123456'}

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'whit valid credentials' do
    before(:each) { post :create, session_params }

    it 'should respond with success' do

      expect(response).to have_http_status(:success)
    end

  	it 'should respond with user token' do

      expect(json_body[:token]).not_to be_empty
  	end
  end
end