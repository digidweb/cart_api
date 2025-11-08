class CartItemsController < ApplicationController
  before_action :set_product, only: [:create]
  before_action :set_cart_item, only: [:update, :destroy]

  # POST /cart_items
  def create
    quantity = params[:quantity]&.to_i || 1

    cart_item = current_cart.add_product(@product, quantity)

    if cart_item
      if request.format.json?
        render json: {
          cart_item: cart_item.info,
          cart: current_cart.summary
        }, status: :created
      else
        redirect_to cart_path, notice: 'Produto adicionado ao carrinho'
      end
    else
      if request.format.json?
        render json: { error: 'Erro ao adicionar produto' }, status: :unprocessable_entity
      else
        redirect_to products_path, alert: 'Erro ao adicionar produto'
      end
    end
  end

  # PATCH/PUT /cart_items/:id
  def update
    quantity = params[:quantity].to_i

    if quantity > 0 && current_cart.update_quantity(@cart_item.product, quantity)
      if request.format.json?
        render json: {
          message: 'Quantidade atualizada',
          cart: current_cart.summary
        }, status: :ok
      else
        redirect_to cart_path, notice: 'Quantidade atualizada'
      end
    else
      if request.format.json?
        render json: { error: 'Erro ao atualizar quantidade' }, status: :unprocessable_entity
      else
        redirect_to cart_path, alert: 'Erro ao atualizar quantidade'
      end
    end
  end

  # DELETE /cart_items/:id
  def destroy
    if current_cart.remove_product(@cart_item.product)
      if request.format.json?
        render json: {
          message: 'Produto removido',
          cart: current_cart.summary
        }, status: :ok
      else
        redirect_to cart_path, notice: 'Produto removido do carrinho'
      end
    else
      if request.format.json?
        render json: { error: 'Erro ao remover produto' }, status: :unprocessable_entity
      else
        redirect_to cart_path, alert: 'Erro ao remover produto'
      end
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  rescue ActiveRecord::RecordNotFound
    if request.format.json?
      render json: { error: 'Produto não encontrado' }, status: :not_found
    else
      redirect_to products_path, alert: 'Produto não encontrado'
    end
  end

  def set_cart_item
    @cart_item = current_cart.cart_items.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    if request.format.json?
      render json: { error: 'Item não encontrado' }, status: :not_found
    else
      redirect_to cart_path, alert: 'Item não encontrado'
    end
  end
end
