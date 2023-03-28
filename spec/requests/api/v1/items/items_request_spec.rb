require "rails_helper"

RSpec.describe "Items Request Spec" do 
  describe "get all items" do 
    it "gets all the items" do 
      create_list(:item, 3)

      get "/api/v1/items"

      expect(response).to be_successful 

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to have_key(:data)
      expect(items[:data].count).to eq(3)

      items[:data].each do |item| 
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
  end

  describe "get one item" do 
    it "can return info for one item" do 
      id = create(:item).id

      get "/api/v1/items/#{id}"

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item).to have_key(:data)
      expect(item[:data]).to have_key(:id)
      expect(item[:data]).to have_key(:type)
      expect(item[:data]).to have_key(:attributes)
      expect(item[:data][:type]).to eq("item")
      expect(item[:data][:id]).to be_a(String)
      expect(item[:data][:attributes]).to be_a(Hash)
      expect(item[:data][:attributes][:name]).to be_a(String)
      expect(item[:data][:attributes][:description]).to be_a(String)
      expect(item[:data][:attributes][:unit_price]).to be_a(Float)
      expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
    end

    it "returns an error when an item that doesn't exist is requested" do 
      create(:item)

      expect {get "/api/v1/items/not_even_a_number"}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end