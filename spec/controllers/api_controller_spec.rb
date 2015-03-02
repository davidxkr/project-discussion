require 'rails_helper'

describe ApiController do
  before(:each) { request.headers['Accept'] = "application/vnd.projectdiscussionapp.v1" }

  controller do
    def index
      render text: 'index called'
    end
  end

  context 'Security by application' do

    describe 'with bad credentials' do
      before(:each) { get :index }

      it 'recives a 401 without application token' do
        expect(response).to have_http_status(401)
      end

      it 'response body have bad credentials message' do
        expect(json_body[:message]).to eq('Bad credentials')
      end

      it 'response headers should include WWW-Authenticate' do
        expect(response.headers['WWW-Authenticate']).to eq("Token realm='Application'")
      end

      it 'recives a 401 with incorrect application token' do
        request.headers['HTTP_AUTHORIZATION'] = "Token token=1111"
        expect(response).to have_http_status(401)
      end
    end

    describe 'with good credentials' do
      let(:application) { create(:application) }

      it 'recives a 200'  do
        request.headers['HTTP_AUTHORIZATION'] = "Token token=#{application.token}"
        get :index
        expect(response).to have_http_status(200)
      end
    end

    describe 'when the application is inactive' do
      it 'recives a 401' do
        application = create(:application, enable: false)
        request.headers['HTTP_AUTHORIZATION'] = "Token token=#{application.token}"
        get :index
        expect(response).to have_http_status(401)
      end
    end
  end
end

describe ApiController do
  before(:each) {  include_default_accept_headers  }

  controller do
    before_filter :authenticate_user!

    def index
      render text: 'index called'
    end
  end

  describe 'Security by bearer token' do
    context 'invalid user token' do

      it 'recives a 401 when no bearer token is present' do
        get :index

        expect(response).to have_http_status(401)
      end

      it 'recives a 401 when bearer token is invalid' do
        request.headers['HTTP_X_AUTHORIZATION'] = "Bearer token=1111111"
        get :index

        expect(response).to have_http_status(401)
     end

     it { expect(controller.send(:current_user?)).to be false }

     it { expect(controller.send(:current_user)).to be nil }
    end

    context 'with valid bearer token' do
      before(:each) do
         session =  build(:session)
         session.set_token
         @user = create(:user, session: session)
         request.headers['HTTP_X_AUTHORIZATION'] = "Bearer token=#{@user.session_token}"

         get :index
      end

      it { expect(response).to have_http_status(200) }

      it { expect(controller.send(:current_user?)).to be true }

      it { expect(controller.send(:current_user)).to be_eql(@user) }
    end
  end
end