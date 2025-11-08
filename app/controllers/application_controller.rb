class ApplicationController < ActionController::API
  protect_from_forgery with: :null_session

  # Helper para encontrar ou criar carrinho na sessão
  before_action :set_cart

  private

  def set_cart
    @cart = Cart.find_by(id: session[:cart_id])

    if @cart.nil?
      @cart = Cart.create
      session[:cart_id] = @cart.id
    elsif @cart.stale?
      # Opcionalmente marcar carrinho inativo como abandonado
      @cart.mark_as_abandoned! if @cart.active?
      @cart = Cart.create
      session[:cart_id] = @cart.id
    end
  end

  def current_cart
    @cart
  end

  helper_method :current_cart
end
