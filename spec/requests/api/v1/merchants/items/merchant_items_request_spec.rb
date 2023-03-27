require "rails_helper"

RSpec.describe "Merchant Items Requests" do 
  describe "all items for a given merchant" do 
    it "can get all items for a given merchant" do 
      merchant = merchant_with_items
      
      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to be_successful

      merchant_items = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_items).to have_key(:data)

      merchant_items[:data].each do |item| 
        expect(item).to have_key(:id)
        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes]).to have_key(:merchant_id)

        expect(item[:id].to_i).to be_an(Integer)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:description]).to be_an(String)
        expect(item[:attributes][:merchant_id].to_i).to be_an(Integer)
      end
    end

    it "returns an error when an incorrect merchant id is given" do 
      merchant = merchant_with_items 

      expect {get "/api/v1/merchants/9999/items"}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end