FactoryBot.define do
  factory :user do
    admin { false }
    name { 'テストユーザー' }
    sequence(:email) { |n| "test#{n}@email.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
