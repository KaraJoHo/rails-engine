FactoryBot.define do 
  factory :invoice_item do 
    quantity {Faker::Number.within(range: 1..12)}
    unit_price {Faker::Number.within(range: 1.00..200.00)}
    item 
    invoice
  end
end