class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  # GET /products
  def index
    @products = Product.by_name

    render json: @products if request.format.json?
  end

  # GET /products/:id
  def show
    render json: @product if request.format.json?
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    if request.format.json?
      render json: { error: 'Produto não encontrado' }, status: :not_found
    else
      redirect_to products_path, alert: 'Produto não encontrado'
    end
  end
end
