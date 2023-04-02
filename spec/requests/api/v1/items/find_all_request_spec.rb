require "rails_helper"

RSpec.describe "Find All Items Request" do 
  describe "find all items by name search" do 
    it "finds all the items that match a name query" do 
      merchant = create(:merchant)

      item_1 = create(:item, merchant_id: merchant.id, name: "Cat Food")
      item_2 = create(:item, merchant_id: merchant.id, name: "Treats for cats")
      item_3 = create(:item, merchant_id: merchant.id, name: "Dog Food")

      get "/api/v1/items/find_all?name=cat"

      expect(response).to be_successful

      found_items = JSON.parse(response.body, symbolize_names: true)

      expect(found_items[:data].count).to eq(2)
      expect(found_items[:data].first[:attributes][:name]).to eq("Cat Food")
      expect(found_items[:data].last[:attributes][:name]).to eq("Treats for cats")
    end

    it "returns nothing if no name is matching" do 
      merchant = create(:merchant)

      item_1 = create(:item, merchant_id: merchant.id, name: "Cat Food")
      item_2 = create(:item, merchant_id: merchant.id, name: "Treats for cats")
      item_3 = create(:item, merchant_id: merchant.id, name: "Dog Food")

      get "/api/v1/items/find_all?name=cow"

      expect(response).to be_successful

      no_data = JSON.parse(response.body, symbolize_names: true)
      expect(no_data[:data].count).to eq(0)
    end
  end

  before(:each) do 
    @merchant = create(:merchant)

    @item_1 = create(:item, name: "B", merchant_id: @merchant.id, unit_price: 10.00)
    @item_2 = create(:item, name: "C", merchant_id: @merchant.id, unit_price: 2.00)
    @item_3 = create(:item, name: "A", merchant_id: @merchant.id, unit_price: 5.00)
  end

  describe "find all items by a price query search" do 
    it "find all items equal to or greater than the searched min price" do 

      get "/api/v1/items/find_all?min_price=5"

      expect(response).to be_successful

      found_items = JSON.parse(response.body, symbolize_names: true)
     
      expect(found_items[:data].count).to eq(2)
      expect(found_items[:data].first[:id].to_i).to eq(@item_3.id)
      expect(found_items[:data].last[:id].to_i).to eq(@item_1.id)

    end

    it "cannot search for something under 0" do 

      get "/api/v1/items/find_all?min_price=-1"

      expect(response).to_not be_successful

      found_items = JSON.parse(response.body, symbolize_names: true)
     
      expect(found_items[:errors]).to eq("Can't be less than zero")
    end

    it "can return all items equal to or less than the given max price" do

      get "/api/v1/items/find_all?max_price=9"

      expect(response).to be_successful

      found_items = JSON.parse(response.body, symbolize_names: true)
     
      expect(found_items[:data].count).to eq(2)
      expect(found_items[:data].first[:id].to_i).to eq(@item_3.id)
      expect(found_items[:data].last[:id].to_i).to eq(@item_2.id)

    end 

    it "returns items between the min and max price given" do 

      get "/api/v1/items/find_all?max_price=9&min_price=1"

      expect(response).to be_successful

      found_items = JSON.parse(response.body, symbolize_names: true)
     
      expect(found_items[:data].count).to eq(2)
      expect(found_items[:data].first[:id].to_i).to eq(@item_3.id)
      expect(found_items[:data].last[:id].to_i).to eq(@item_2.id)

    end

    it "cannot search for name and price at the same time" do 

      get "/api/v1/items/find_all?max_price=9&name=karen"

      expect(response).to_not be_successful

      found_items = JSON.parse(response.body, symbolize_names: true)
     
      expect(found_items[:errors]).to eq("Cannot search with name and price")
      expect(response.status).to eq(400)
    end

    it "renders an error if nothing is searched for" do 

      get "/api/v1/items/find_all"

      expect(response).to_not be_successful

      found_items = JSON.parse(response.body, symbolize_names: true)
     
      expect(found_items[:errors]).to eq("Something went wrong")
    end

    it "renders an error if the parameter is empty" do 

      get "/api/v1/items/find_all?name="

      expect(response).to_not be_successful

      found_items = JSON.parse(response.body, symbolize_names: true)
     
      expect(found_items[:errors]).to eq("Parameter cannot be empty")
    end
  end
end