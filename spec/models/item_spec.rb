require "rails_helper"

RSpec.describe Item do 
  describe "validations" do 
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_numericality_of :unit_price}
  end

  describe "relationships" do 
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
    it {should have_many(:invoices).through(:invoice_items)}
  end

  describe "find_bys" do 
    it "finds a list of items by a name search" do 
      merchant = create(:merchant)

      item_1 = create(:item, merchant_id: merchant.id, name: "Cat Food")
      item_2 = create(:item, merchant_id: merchant.id, name: "Treats for cats")
      item_3 = create(:item, merchant_id: merchant.id, name: "Dog Food")

      expect(Item.find_by_name_search("cat")).to eq([item_1, item_2])
      expect(Item.find_by_name_search("cAt")).to eq([item_1, item_2])
      expect(Item.find_by_name_search("CA")).to eq([item_1, item_2])
      expect(Item.find_by_name_search("cAtS")).to eq([item_2])
      expect(Item.find_by_name_search("aT")).to eq([item_1, item_2])
      expect(Item.find_by_name_search("food")).to eq([item_1, item_3])
    end

    it "finds items by name sorted alphabetically" do 
      merchant = create(:merchant)

      item_1 = create(:item, merchant_id: merchant.id, name: "Timothy's Cat Food")
      item_2 = create(:item, merchant_id: merchant.id, name: "Ariel's Cat Food")
      item_3 = create(:item, merchant_id: merchant.id, name: "Dog Food")

      expect(Item.find_by_name_search("cat")).to eq([item_2, item_1])
      expect(Item.find_by_name_search("cat")).to_not eq([item_1, item_2])
    end

    it "finds a list of items by a min_price search, ordered alphabetically by name" do 
      merchant = create(:merchant)

      item_1 = create(:item, name: "B", merchant_id: merchant.id, unit_price: 10.00)
      item_2 = create(:item, merchant_id: merchant.id, unit_price: 2.00)
      item_3 = create(:item, name: "A", merchant_id: merchant.id, unit_price: 5.00)

      expect(Item.find_by_min_price("5.00")).to eq([item_3, item_1])
    end

    it "finds a list of items by a max_price search, ordered alphabetically" do 
      merchant = create(:merchant)

      item_1 = create(:item, name: "B", merchant_id: merchant.id, unit_price: 10.00)
      item_2 = create(:item, name: "C", merchant_id: merchant.id, unit_price: 2.00)
      item_3 = create(:item, name: "A", merchant_id: merchant.id, unit_price: 5.00)

      expect(Item.find_by_max_price("9.00")).to eq([item_3, item_2])
    end

    it "finds the price between the max and min given" do 
      merchant = create(:merchant)

      item_1 = create(:item, name: "B", merchant_id: merchant.id, unit_price: 10.00)
      item_2 = create(:item, name: "C", merchant_id: merchant.id, unit_price: 2.00)
      item_3 = create(:item, name: "A", merchant_id: merchant.id, unit_price: 5.00)

      expect(Item.find_by_price_between("9.00", "1.00")).to eq([item_3, item_2])
    end
  end

  describe "delete_invoices_from_item" do 
    it "destroys the invoices on the item where there is only once invoice with the item" do 
      merchant = create(:merchant)
      customer = create(:customer)

      item_1 = create(:item, merchant_id: merchant.id)
      item_2 = create(:item, merchant_id: merchant.id)
      item_3 = create(:item, merchant_id: merchant.id)

      invoice_1 = create(:invoice, merchant_id: merchant.id, customer_id: customer.id)
      invoice_2 = create(:invoice, merchant_id: merchant.id, customer_id: customer.id)
      invoice_3 = create(:invoice, merchant_id: merchant.id, customer_id: customer.id)

      ii_1 = create(:invoice_item, invoice_id: invoice_2.id, item_id: item_1.id)
      ii_2 = create(:invoice_item, invoice_id: invoice_3.id, item_id: item_1.id)

      ii_3 = create(:invoice_item, invoice_id: invoice_1.id, item_id: item_1.id)
      ii_4 = create(:invoice_item, invoice_id: invoice_1.id, item_id: item_2.id)
      ii_5 = create(:invoice_item, invoice_id: invoice_1.id, item_id: item_3.id)

      expect(item_1.invoices.only_one_item).to eq([invoice_2, invoice_3])
     
      item_1.destroy 
     
      expect(Invoice.all.count).to eq(1)
      expect(Item.all.count).to eq(2)

      expect(Invoice.exists?(invoice_2.id)).to be(false)
      expect(Invoice.exists?(invoice_3.id)).to be(false)
      expect(Invoice.exists?(invoice_1.id)).to be(true)

      expect(Item.exists?(item_1.id)).to be(false)
      expect(Item.exists?(item_2.id)).to be(true)
      expect(Item.exists?(item_3.id)).to be(true)
      expect(Invoice.find(invoice_1.id)).to eq(invoice_1)
      expect(Item.find(item_2.id)).to eq(item_2)
      expect(Item.find(item_3.id)).to eq(item_3) 
    end
  end
end