class Api::V1::Merchants::SearchController < ApplicationController
  def search
    if !Merchant.find_by_name_query(params[:name]).nil?
      render json: V1::MerchantSerializer.new(Merchant.find_by_name_query(params[:name]))
    else 
      render json: {data: {}}
    end
  end
end