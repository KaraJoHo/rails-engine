require "rails_helper"

RSpec.describe "Merchant API" do 
  describe "get all merchants" do 
    it "can get all merchants" do 
      create_list(:merchant, 3)

      get "/api/v1/merchants"

      expect(response).to be_successful 

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants).to have_key(:data)

      expect(merchants[:data].count).to eq(3)

      merchants[:data].each do |merchant| 
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(Integer) 

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq("merchant")

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
  end
end