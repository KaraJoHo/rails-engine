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
      get "/api/v1/items/not_even_a_number"

      item_not_existing = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(404)
      expect(item_not_existing).to have_key(:error)
      expect(item_not_existing).to have_key(:message)
      expect(item_not_existing[:error]).to eq("Couldn't find Item with 'id'=not_even_a_number")
      expect(item_not_existing[:message]).to eq("your query could not be completed")
    end
  end

  describe "create an item" do 
    it "can create a new item" do 
      create(:merchant, id: 14)
      item_params = ({
                      name: "Very Cool Item",
                      description: "It is a very cool item",
                      unit_price: 100.99,
                      merchant_id: 14
                    })
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      created_item = Item.last

      expect(response).to be_successful 
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end

    it "will not create an item if a parameter isn't given" do 
      create(:merchant, id: 14)
      item_params = ({
                      name: "Very Cool Item",
                      unit_price: 100.99,
                      merchant_id: 14
                    })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      cannot_create = JSON.parse(response.body, symbolize_names: true)

      expect(cannot_create).to have_key(:errors)
      expect(cannot_create).to have_key(:message)
      expect(cannot_create).to have_key(:data)
      expect(cannot_create[:data][:id]).to eq(nil)
      expect(cannot_create[:data][:attributes]).to eq({})
      expect(cannot_create[:errors][0]).to have_key(:description)
      expect(cannot_create[:errors][0][:description]).to eq(["can't be blank"])
      expect(response.status).to eq(404)  
    end
  end

  describe "update an item" do 
    it "can update an existing item" do 
      create(:merchant, id: 14)
      id = create(:item, merchant_id: 14).id 
      previous_name = Item.last.name 
      item_params = {name: "Totally New Name"}
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: id)

      expect(response).to be_successful 
      expect(item.name).to eq("Totally New Name")
      expect(item.name).to_not eq(previous_name)

    end

    it "does not update for merchant that doesnt exist" do
      create(:merchant, id: 14)
      id = create(:item, merchant_id: 14).id 
      previous_merchant_id = Item.last.merchant_id
      item_params = {merchant_id: 999999999}
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})

      cannot_update = JSON.parse(response.body, symbolize_names: true)

      expect(cannot_update).to have_key(:errors)
      expect(cannot_update).to have_key(:message)
      expect(cannot_update).to have_key(:data)
      expect(cannot_update[:data][:id]).to eq(nil)
      expect(cannot_update[:data][:attributes]).to eq({})
      expect(cannot_update[:errors][0]).to have_key(:merchant)
      expect(cannot_update[:errors][0][:merchant]).to eq(["must exist"])
      expect(response.status).to eq(404)
    end
  end

  describe "delete an item" do 
    it "can delete an item" do 
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful 
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "doesn't delete a record that doesn't exist" do 
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
      
      delete "/api/v1/items/1111111" 

      item_not_existing = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(404)
      expect(item_not_existing).to have_key(:error)
      expect(item_not_existing).to have_key(:message)
      expect(item_not_existing[:error]).to eq("Couldn't find Item with 'id'=1111111")
      expect(item_not_existing[:message]).to eq("your query could not be completed")
    end
  end
end