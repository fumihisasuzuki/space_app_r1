FactoryBot.define do
  factory :user do
    user_name { "sample-name" }
    email { "sample@email.com" }
    password { "password" }
    admin { false }
  end
end
