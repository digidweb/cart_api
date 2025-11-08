# spec/factories/carts.rb
FactoryBot.define do
  factory :cart do
    status { 'active' }
    last_interaction_at { Time.current }
    abandoned_at { nil }

    # Variações da factory
    trait :active do
      status { 'active' }
      last_interaction_at { Time.current }
      abandoned_at { nil }
    end

    trait :abandoned do
      status { 'abandoned' }
      abandoned_at { Time.current }
    end

    trait :completed do
      status { 'completed' }
    end

    trait :stale do
      status { 'active' }
      last_interaction_at { 1.hour.ago }
    end

    trait :old_abandoned do
      status { 'abandoned' }
      abandoned_at { 10.days.ago }
    end

    trait :with_products do
      transient do
        products_count { 3 }
      end

      after(:create) do |cart, evaluator|
        create_list(:cart_item, evaluator.products_count, cart: cart)
      end
    end

    # Factory para carrinho com itens específicos
    factory :cart_with_items, traits: [:with_products]
  end
end
