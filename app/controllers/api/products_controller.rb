class Api::ProductsController < ApplicationController
  def search
    render :json => Product.query(params[:code], params[:format])
  rescue ProductFetcher::BadBarcodeError => e
    render :json => {:error => e.message}
  end
end
