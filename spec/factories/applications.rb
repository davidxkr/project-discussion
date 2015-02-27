FactoryGirl.define do
  factory :application do
    token { SecureRandom.base64(30).tr('+/=', 'A9B').strip }
    name "Ios App"
    enable true
  end
end