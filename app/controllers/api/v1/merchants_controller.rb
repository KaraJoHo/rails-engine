class Api::V1::MerchantsController < ApplicationController 
  def index 
    merchants = Merchant.all
    render json: V1::MerchantSerializer.new(merchants)

  end

  def show 
    render json: V1::MerchantSerializer.new(Merchant.find(params[:id]))
  end
end