FactoryBot.define do 
  factory :invoice do 
    status {Faker::Lorem.word}
    customer 
    merchant
  end
end