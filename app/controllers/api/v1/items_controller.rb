class Api::V1::ItemsController < ApplicationController 
  def index 
    render json: Api::V1::ItemSerializer.new(Item.all)
  end

  def show 
    render json: Api::V1::ItemSerializer.new(Item.find(params[:id]))
  end
end