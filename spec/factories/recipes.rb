FactoryBot.define do
  factory :recipe do
    name { 'レシピ１' }
    description { '内容1' }
    user
  end
end
