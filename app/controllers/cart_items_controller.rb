class CartItemsController < ApplicationController
  before_action :set_product, only: [:create]
  before_action :set_cart_item, only: [:update, :destroy]

  # POST /cart_items
  def create
    quantity = params[:quantity]&.to_i || 1

    cart_item = current_cart.add_product(@product, quantity)

    if cart_item
      respond_to do |format|
        format.html { redirect_to cart_path, notice: 'Produto adicionado ao carrinho' }
        format.json { render json: { cart_item: cart_item.info, cart: current_cart.summary }, status: :created }
      end
    else
      respond_to do |format|
        format.html { redirect_to products_path, alert: 'Erro ao adicionar produto' }
        format.json { render json: { error: 'Erro ao adicionar produto' }, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cart_items/:id
  def update
    quantity = params[:quantity].to_i

    if current_cart.update_quantity(@cart_item.product, quantity)
      respond_to do |format|
        format.html { redirect_to cart_path, notice: 'Quantidade atualizada' }
        format.json { render json: { message: 'Quantidade atualizada', cart: current_cart.summary }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to cart_path, alert: 'Erro ao atualizar quantidade' }
        format.json { render json: { error: 'Erro ao atualizar quantidade' }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cart_items/:id
  def destroy
    if current_cart.remove_product(@cart_item.product)
      respond_to do |format|
        format.html { redirect_to cart_path, notice: 'Produto removido do carrinho' }
        format.json { render json: { message: 'Produto removido', cart: current_cart.summary }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to cart_path, alert: 'Erro ao remover produto' }
        format.json { render json: { error: 'Erro ao remover produto' }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to products_path, alert: 'Produto não encontrado' }
      format.json { render json: { error: 'Produto não encontrado' }, status: :not_found }
    end
  end

  def set_cart_item
    @cart_item = current_cart.cart_items.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to cart_path, alert: 'Item não encontrado' }
      format.json { render json: { error: 'Item não encontrado' }, status: :not_found }
    end
  end
end
