class Api::V1::ItemsController < ApplicationController 
  def index 
    render json: V1::ItemSerializer.new(Item.all)
  end

  def show 
    render json: V1::ItemSerializer.new(Item.find(params[:id]))
  end

  def create 
    merchant = Merchant.find(params["item"]["merchant_id"])
    render json: V1::ItemSerializer.new(merchant.items.create!(item_params)), status: :created
  end

  def update 
    item = Item.find(params[:id])
    if item.update!(item_params)
      render json: V1::ItemSerializer.new(item), status: 201
    else 
      render json: "", status: 404 
    end
  end

  def destroy 
    render json: Item.destroy(params[:id])
  end

  private
    def item_params 
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end