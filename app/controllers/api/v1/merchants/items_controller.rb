class Api::V1::Merchants::ItemsController < ApplicationController 
  def index 
    render json: V1::ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
  end
end