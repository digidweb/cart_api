require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe 'validations' do
    it 'é válido com atributos válidos' do
      cart_item = build(:cart_item)
      expect(cart_item).to be_valid
    end

    it 'requer quantidade' do
      cart_item = build(:cart_item, quantity: nil)
      expect(cart_item).not_to be_valid
    end

    it 'requer quantidade maior que zero' do
      cart_item = build(:cart_item, quantity: 0)
      expect(cart_item).not_to be_valid
    end

    it 'não permite produto duplicado no mesmo carrinho' do
      cart = create(:cart)
      product = create(:product)
      create(:cart_item, cart: cart, product: product)

      duplicate = build(:cart_item, cart: cart, product: product)
      expect(duplicate).not_to be_valid
    end
  end

  describe 'associations' do
    it 'pertence a um cart' do
      expect(CartItem.reflect_on_association(:cart).macro).to eq(:belongs_to)
    end

    it 'pertence a um product' do
      expect(CartItem.reflect_on_association(:product).macro).to eq(:belongs_to)
    end
  end

  describe '#subtotal' do
    it 'calcula subtotal corretamente' do
      product = create(:product, price: 100.00)
      cart_item = create(:cart_item, product: product, quantity: 3)

      expect(cart_item.subtotal).to eq(300.00)
    end
  end

  describe '#info' do
    it 'retorna hash com informações do item' do
      cart_item = create(:cart_item)
      info = cart_item.info

      expect(info).to be_a(Hash)
      expect(info).to have_key(:product_name)
      expect(info).to have_key(:quantity)
      expect(info).to have_key(:subtotal)
    end
  end
end
