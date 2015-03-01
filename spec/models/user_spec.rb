require 'rails_helper'

describe User, 'Attributes' do
  it {respond_to :email}
  it {respond_to :name}
end

describe User, 'Validations' do
  subject { build(:user) }
  it { expect(subject).to validate_presence_of :email }
  it { expect(subject).to validate_presence_of :name }
  it { expect(subject).to validate_uniqueness_of :email }
end

describe User, 'Relations' do
  it { expect(subject).to have_one(:session) }
end