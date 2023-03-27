class Api::V1::MerchantsController < ApplicationController 
  def index 
    merchants = Merchant.all
    render json: Api::V1::MerchantSerializer.format_merchants(merchants)
  end

  def show 
    render json: Api::V1::MerchantSerializer.format_merchant(Merchant.find(params[:id]))
  end
end