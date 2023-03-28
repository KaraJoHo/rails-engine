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

      expect{get "/api/v1/items/500000000/merchant"}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end