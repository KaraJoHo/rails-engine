require "rails_helper"

RSpec.describe "Item's Merchant Request" do 
  describe "get an item's merchant data" do 
    it "gets the merchant data from a given item id" do 
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful

      merchant_of_item = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_of_item[:data][:id].to_i).to eq(merchant.id)

    end

    it "raises an error when a bad item id is given" do 
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      get "/api/v1/items/500000000/merchant" 

      bad_id_response = JSON.parse(response.body, symbolize_names: true)

      expect(bad_id_response).to have_key(:error)
      expect(bad_id_response).to have_key(:message)
      expect(bad_id_response[:error]).to eq("Couldn't find Item with 'id'=500000000")
      expect(bad_id_response[:message]).to eq("your query could not be completed")
    end
  end
end