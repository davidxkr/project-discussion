require 'rails_helper'

describe Application, "Attributes" do
  it{ respond_to :name }
  it{ respond_to :token }
  it{ respond_to :enable }
end

describe Application, 'Validations' do
  subject { build(:application) }
  it { expect(subject).to validate_presence_of :name }
  it { expect(subject).to validate_presence_of :token }
  it { expect(subject).to validate_uniqueness_of :token }
end