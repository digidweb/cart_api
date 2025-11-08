class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  # GET /products
  def index
    @products = Product.by_name

    respond_to do |format|
      format.html
      format.json { render json: @products }
    end
  end

  # GET /products/:id
  def show
    respond_to do |format|
      format.html
      format.json { render json: @product }
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to products_path, alert: 'Produto não encontrado' }
      format.json { render json: { error: 'Produto não encontrado' }, status: :not_found }
    end
  end
end
