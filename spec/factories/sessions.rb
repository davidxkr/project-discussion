FactoryGirl.define do
  factory :session do
    association :user, strategy: :build
    token nil
    ip_address "127.0.0.1"
  end
end