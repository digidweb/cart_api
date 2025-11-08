class CartsController < ApplicationController
  # GET /cart
  def show
    @cart = current_cart

    if request.format.json?
      render json: @cart.detailed_summary
    end
  end

  # POST /cart/clear
  def clear
    current_cart.clear!

    if request.format.json?
      render json: { message: 'Carrinho esvaziado' }, status: :ok
    else
      redirect_to cart_path, notice: 'Carrinho esvaziado com sucesso'
    end
  end

  # POST /cart/complete
  def complete
    if current_cart.empty?
      if request.format.json?
        render json: { error: 'Carrinho vazio' }, status: :unprocessable_entity
      else
        redirect_to cart_path, alert: 'Carrinho vazio'
      end
      return
    end

    current_cart.complete!
    session[:cart_id] = nil

    if request.format.json?
      render json: { message: 'Pedido finalizado', cart: current_cart.detailed_summary }, status: :ok
    else
      redirect_to root_path, notice: 'Pedido finalizado com sucesso!'
    end
  end
end
