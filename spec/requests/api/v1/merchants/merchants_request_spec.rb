require "rails_helper"

RSpec.describe "Merchant API" do 
  describe "get all merchants" do 
    it "can get all merchants" do 
      create_list(:merchant, 3)

      get "/api/v1/merchants"

      expect(response).to be_successful 

      merchants = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchants).to be_an(Array)

      expect(merchants.count).to eq(3)

      merchants.each do |merchant| 
        expect(merchant).to have_key(:id)
        expect(merchant[:id].to_i).to be_an(Integer) 

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq("merchant")

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
  end

  describe "get one merchant" do 
    it "happy path - can get one merchant with an id" do 
      id = create(:merchant).id 

      get "/api/v1/merchants/#{id}"

      merchant = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to be_successful

      expect(merchant).to have_key(:data)
      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data]).to have_key(:attributes)
      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:id]).to be_a(String)
      expect(merchant[:data][:type]).to eq("merchant")
      expect(merchant[:data][:attributes]).to be_a(Hash)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
    end

    it "sad path - is not succuessful with an incorrect id" do 
      create_list(:merchant, 3)
    
      get "/api/v1/merchants/9999"

      incorrect_id = JSON.parse(response.body, symbolize_names: true)

      expect(incorrect_id).to have_key(:error)
      expect(incorrect_id).to have_key(:message)
      expect(incorrect_id[:error]).to eq("Couldn't find Merchant with 'id'=9999")
      expect(incorrect_id[:message]).to eq("your query could not be completed")
    end
  end
end