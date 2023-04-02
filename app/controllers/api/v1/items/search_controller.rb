class Api::V1::Items::SearchController < ApplicationController 
  def search_name
    if params[:name] && (params[:min_price] || params[:max_price])
      render json: ErrorSerializer.new("Cannot search with name and price").bad_request, status: 400
    elsif params[:name] == "" 
      render json: ErrorSerializer.new("Parameter cannot be empty").bad_request, status: 400
    elsif params[:name]
      render json: V1::ItemSerializer.new(Item.find_by_name_search(params[:name]))
    elsif params[:min_price].to_f < 0 || params[:max_price].to_f < 0
      render json: ErrorSerializer.new("Can't be less than zero").bad_request, status: 400
    elsif params[:max_price] && params[:min_price]
      render json: V1::ItemSerializer.new(Item.find_by_price_between(params[:max_price], params[:min_price]))
    elsif params[:min_price] 
      render json: V1::ItemSerializer.new(Item.find_by_min_price(params[:min_price]))
    elsif params[:max_price]
      render json: V1::ItemSerializer.new(Item.find_by_max_price(params[:max_price]))
    else 
      render json: ErrorSerializer.new("Something went wrong").bad_request, status: 400
    end
  end
end