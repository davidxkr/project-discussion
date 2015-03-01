require 'rails_helper'

describe Session, 'Attributes' do
  it { respond_to :token }
  it { respond_to :id_address}
end

describe Session, 'Validations' do
  it { expect(subject).to validate_presence_of :token }
  it { expect(subject).to validate_presence_of :ip_address }
end

describe Session, 'Relations' do
  it { expect(subject).to belong_to :user }
end

describe Session, '#set_token' do
  let(:session) { build(:session) }

  it 'generate a token' do
  	expect(session.set_token).to be_a(String)
  end
end