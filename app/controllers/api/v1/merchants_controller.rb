class Api::V1::MerchantsController < ApplicationController 
  def index 
    merchants = Merchant.all
    render json: Api::V1::MerchantSerializer.format_merchants(merchants)
  end
end