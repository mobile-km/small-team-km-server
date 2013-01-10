class Api::ProductsController < ApplicationController
  def search
    render :json => Product.query(params[:code], params[:format])
  end
end
