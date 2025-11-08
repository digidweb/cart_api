# app/models/cart.rb
class Cart < ApplicationRecord
  # === ASSOCIATIONS ===
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  # === VALIDATIONS ===
  validates :status, presence: true,
            inclusion: { in: %w[active abandoned completed],
                        message: "%{value} não é um status válido" }

  # === SCOPES ===
  scope :active, -> { where(status: 'active') }
  scope :abandoned, -> { where(status: 'abandoned') }
  scope :completed, -> { where(status: 'completed') }
  scope :stale, -> { where('last_interaction_at < ?', 30.minutes.ago) }
  scope :recently_abandoned, -> { abandoned.where('abandoned_at > ?', 24.hours.ago) }

  # === CALLBACKS ===
  before_create :set_initial_status
  before_save :update_last_interaction

  # === INSTANCE METHODS ===

  # Adiciona um produto ao carrinho
  def add_product(product, quantity = 1)
    return false unless product&.persisted?

    cart_item = cart_items.find_or_initialize_by(product_id: product.id)

    if cart_item.new_record?
      cart_item.quantity = quantity
    else
      cart_item.quantity += quantity
    end

    if cart_item.save
      touch_interaction
      cart_item
    else
      false
    end
  end

  # Remove um produto do carrinho
  def remove_product(product)
    return false unless product&.persisted?

    cart_item = cart_items.find_by(product_id: product.id)
    if cart_item
      cart_item.destroy
      touch_interaction
      true
    else
      false
    end
  end

  # Atualiza quantidade de um produto
  def update_quantity(product, quantity)
    return false unless product&.persisted?

    cart_item = cart_items.find_by(product_id: product.id)
    return false unless cart_item

    result = if quantity <= 0
      cart_item.destroy
    else
      cart_item.update(quantity: quantity)
    end

    touch_interaction if result
    result
  end

  # Calcula o total do carrinho
  def total
    result = cart_items.joins(:product).sum('products.price * cart_items.quantity')
    result.to_f.round(2)
  end

  # Retorna o valor formatado para exibição
  def formatted_total
    "R$ #{format('%.2f', total)}"
  end

  # Conta total de itens
  def items_count
    cart_items.sum(:quantity)
  end

  # Verifica se o carrinho está vazio
  def empty?
    cart_items.empty?
  end

  # Marca como abandonado
  def mark_as_abandoned!
    update(status: 'abandoned', abandoned_at: Time.current)
  end

  # Marca como completado
  def complete!
    update(status: 'completed')
  end

  # Limpa o carrinho
  def clear!
    cart_items.destroy_all
    touch_interaction
  end

  # Verifica se está inativo há muito tempo
  def stale?
    last_interaction_at && last_interaction_at < 30.minutes.ago
  end

  # Retorna informações completas do carrinho incluindo itens
  def detailed_summary
    {
      cart_id: id,
      status: status,
      items_count: items_count,
      items: items_info,
      total: total,
      formatted_total: formatted_total,
      last_interaction_at: last_interaction_at
    }
  end

  private

  def set_initial_status
    self.status ||= 'active'
  end

  def update_last_interaction
    self.last_interaction_at = Time.current if status == 'active'
  end

  def touch_interaction
    update_column(:last_interaction_at, Time.current)
  end

  # Retorna array com informações de todos os itens
  def items_info
    cart_items.includes(:product).map(&:info)
  end
end
