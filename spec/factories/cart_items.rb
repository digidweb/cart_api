# spec/factories/cart_items.rb
FactoryBot.define do
  factory :cart_item do
    association :cart
    association :product
    quantity { rand(1..5) }

    # Variações da factory
    trait :single_item do
      quantity { 1 }
    end

    trait :multiple_items do
      quantity { rand(2..10) }
    end

    trait :max_quantity do
      quantity { 999 }
    end

    trait :with_cheap_product do
      association :product, factory: [:product, :cheap]
    end

    trait :with_expensive_product do
      association :product, factory: [:product, :expensive]
    end

    # Factory para item com produto específico
    factory :cart_item_with_notebook do
      association :product, factory: :notebook
      quantity { 1 }
    end

    factory :cart_item_with_mouse do
      association :product, factory: :mouse
      quantity { 2 }
    end
  end
end
