require "rails_helper"

RSpec.describe Invoice do 
  describe "relationships" do 
    it {should have_many(:invoice_items)}
    it {should have_many(:items).through(:invoice_items)}
    it {should belong_to(:merchant)}
    it {should belong_to(:customer)}
  end

  describe "validations" do 
    it {should validate_presence_of(:status)}
  end

  describe "only_one_item" do 
    it "is a list of invoices that only have one item" do 
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
    
      expect(Invoice.only_one_item).to match_array([invoice_2, invoice_3])
    end

    it "doesn't have a list of only_one items if it has more than one items on an invoice" do 
      merchant = create(:merchant)
      customer = create(:customer)

      item_1 = create(:item, merchant_id: merchant.id)
      item_2 = create(:item, merchant_id: merchant.id)
      item_3 = create(:item, merchant_id: merchant.id)

      invoice_1 = create(:invoice, merchant_id: merchant.id, customer_id: customer.id)

      ii_3 = create(:invoice_item, invoice_id: invoice_1.id, item_id: item_1.id)
      ii_4 = create(:invoice_item, invoice_id: invoice_1.id, item_id: item_2.id)
      ii_5 = create(:invoice_item, invoice_id: invoice_1.id, item_id: item_3.id)
      
      expect(Invoice.only_one_item).to eq([])
    end
  end
end