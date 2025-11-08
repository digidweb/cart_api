require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it 'é válido com atributos válidos' do
      product = build(:product)
      expect(product).to be_valid
    end

    it 'requer um nome' do
      product = build(:product, name: nil)
      expect(product).not_to be_valid
    end

    it 'requer um preço' do
      product = build(:product, price: nil)
      expect(product).not_to be_valid
    end

    it 'requer preço maior que zero' do
      product = build(:product, price: -10)
      expect(product).not_to be_valid
    end
  end

  describe 'associations' do
    it 'tem muitos cart_items' do
      expect(Product.reflect_on_association(:cart_items).macro).to eq(:has_many)
    end

    it 'tem muitos carts através de cart_items' do
      expect(Product.reflect_on_association(:carts).macro).to eq(:has_many)
    end
  end

  describe '#formatted_price' do
    it 'retorna preço formatado' do
      product = create(:product, price: 1234.56)
      expect(product.formatted_price).to eq('R$ 1234.56')
    end
  end
end
