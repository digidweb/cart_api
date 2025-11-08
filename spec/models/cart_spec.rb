require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'validations' do
    it 'é válido com status válido' do
      cart = build(:cart, status: 'active')
      expect(cart).to be_valid
    end

    it 'não é válido com status inválido' do
      cart = build(:cart, status: 'invalid')
      expect(cart).not_to be_valid
    end
  end

  describe 'associations' do
    it 'tem muitos cart_items' do
      expect(Cart.reflect_on_association(:cart_items).macro).to eq(:has_many)
    end

    it 'tem muitos products através de cart_items' do
      expect(Cart.reflect_on_association(:products).macro).to eq(:has_many)
    end
  end

  describe '#add_product' do
    let(:cart) { create(:cart) }
    let(:product) { create(:product) }

    it 'adiciona produto ao carrinho' do
      cart.add_product(product, 2)
      expect(cart.cart_items.count).to eq(1)
      expect(cart.cart_items.first.quantity).to eq(2)
    end

    it 'incrementa quantidade se produto já existe' do
      cart.add_product(product, 1)
      cart.add_product(product, 2)
      expect(cart.cart_items.count).to eq(1)
      expect(cart.cart_items.first.quantity).to eq(3)
    end
  end

  describe '#total' do
    it 'calcula total corretamente' do
      cart = create(:cart)
      product1 = create(:product, price: 100.00)
      product2 = create(:product, price: 50.00)

      cart.add_product(product1, 2)  # 200
      cart.add_product(product2, 3)  # 150

      expect(cart.total).to eq(350.00)
    end
  end

  describe '#empty?' do
    it 'retorna true para carrinho vazio' do
      cart = create(:cart)
      expect(cart.empty?).to be true
    end

    it 'retorna false para carrinho com itens' do
      cart = create(:cart_with_items, products_count: 1)
      expect(cart.empty?).to be false
    end
  end

  describe '#mark_as_abandoned!' do
    it 'marca carrinho como abandonado' do
      cart = create(:cart, :active)
      cart.mark_as_abandoned!

      expect(cart.status).to eq('abandoned')
      expect(cart.abandoned_at).not_to be_nil
    end
  end
end
