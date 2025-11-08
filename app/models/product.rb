# app/models/product.rb
class Product < ApplicationRecord
  # === ASSOCIATIONS ===
  has_many :cart_items, dependent: :destroy
  has_many :carts, through: :cart_items

  # === VALIDATIONS ===
  validates :name, presence: true,
            length: { minimum: 3, maximum: 255 },
            uniqueness: { case_sensitive: false }

  validates :price, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 999999.99 }

  # === SCOPES ===
  scope :available, -> { where('price > ?', 0) }
  scope :by_name, -> { order(:name) }
  scope :expensive, -> { where('price > ?', 100) }
  scope :cheap, -> { where('price <= ?', 50) }

  # === CALLBACKS ===
  before_save :normalize_name

  # === INSTANCE METHODS ===

  # Formata o preço para exibição
  def formatted_price
    "R$ #{format('%.2f', price)}"
  end

  # Verifica se o produto está em algum carrinho ativo
  def in_active_carts?
    carts.active.exists?
  end

  # Conta quantas vezes foi adicionado em carrinhos
  def times_added_to_cart
    cart_items.count
  end

  # Total vendido (em carrinhos completados)
  def total_sold
    cart_items.joins(:cart)
              .where(carts: { status: 'completed' })
              .sum(:quantity)
  end

  private

  def normalize_name
    self.name = name.strip.titleize if name.present?
  end
end
