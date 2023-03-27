FactoryBot.define do 
  factory :merchant do 
    name {Faker::Name.name}
  end

  factory :item do 
    name {Faker::Dessert.variety}
    description {Faker::Lorem.sentence(word_count: 5)}
    unit_price{Faker::Number.within(range: 1.00..200.00)}
    merchant
  end
end

 def merchant_with_items(items_count: 2)
  FactoryBot.create(:merchant) do |merchant| 
    FactoryBot.create_list(:item, items_count, merchant: merchant)
  end
 end

