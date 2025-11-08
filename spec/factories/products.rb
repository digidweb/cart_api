# spec/factories/products.rb
FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    price { Faker::Commerce.price(range: 10.0..5000.0) }

    # Variações da factory
    trait :cheap do
      price { Faker::Commerce.price(range: 10.0..50.0) }
    end

    trait :expensive do
      price { Faker::Commerce.price(range: 1000.0..5000.0) }
    end

    trait :free do
      price { 0.0 }
    end

    trait :with_specific_name do
      name { "Notebook Dell Inspiron" }
    end

    # Factory para produtos específicos
    factory :notebook do
      name { "Notebook #{Faker::Company.name}" }
      price { Faker::Commerce.price(range: 2000.0..5000.0) }
    end

    factory :mouse do
      name { "Mouse #{Faker::Company.name}" }
      price { Faker::Commerce.price(range: 50.0..500.0) }
    end

    factory :keyboard do
      name { "Teclado #{Faker::Company.name}" }
      price { Faker::Commerce.price(range: 100.0..800.0) }
    end
  end
end
