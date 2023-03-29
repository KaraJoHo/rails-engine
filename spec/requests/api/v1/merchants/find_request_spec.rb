require "rails_helper"

RSpec.describe "Find Merchant Request" do 
  describe "find a merchant" do 
    it "finds a merchant based on  search criteria" do 
      merchant_1 = create(:merchant, name: "Awesome Pizza")
      merchant_2 = create(:merchant, name: "Vintage Mirrors")

      get "/api/v1/merchants/find?name=Awesome"

      expect(response).to be_successful

      found_merchant = JSON.parse(response.body, symbolize_names: true)

      expect(found_merchant[:data][:id].to_i).to eq(merchant_1.id)
      expect(found_merchant[:data][:id].to_i).to_not eq(merchant_2.id)
      expect(found_merchant[:data][:attributes][:name]).to eq("Awesome Pizza")
    end

    it "is null when no object is found" do 
      merchant_1 = create(:merchant, name: "Awesome Pizza")
      merchant_2 = create(:merchant, name: "Vintage Mirrors")

      get "/api/v1/merchants/find?name=cat"

      no_data = JSON.parse(response.body, symbolize_names: true)
      
      expect(no_data).to be_a(Hash)
      expect(no_data[:data].count).to eq(0)
    end
  end
end