# app/models/cart_item.rb
class CartItem < ApplicationRecord
  # === ASSOCIATIONS ===
  belongs_to :cart
  belongs_to :product

  # === VALIDATIONS ===
  validates :quantity, presence: true,
            numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 999 }

  validates :product_id, uniqueness: { scope: :cart_id,
                                       message: "já está no carrinho" }

  # === CALLBACKS ===
  after_save :touch_cart
  after_destroy :touch_cart

  # === INSTANCE METHODS ===

  # Calcula o subtotal do item
  def subtotal
    (product.price * quantity).to_f.round(2)
  end

  # Formata o subtotal para exibição
  def formatted_subtotal
    "R$ #{format('%.2f', subtotal).gsub('.', ',')}"
  end

  # Aumenta a quantidade
  def increment_quantity(amount = 1)
    self.quantity += amount
    save
  end

  # Diminui a quantidade
  def decrement_quantity(amount = 1)
    self.quantity -= amount
    quantity > 0 ? save : destroy
  end

  # Retorna informações do item
  def info
    {
      product: product.name,
      quantity: quantity,
      unit_price: (product.price).to_f.round(2),
      subtotal: subtotal,
      formatted_subtotal: formatted_subtotal
    }
  end

  private

  def touch_cart
    cart.touch(:last_interaction_at)
  end
end
