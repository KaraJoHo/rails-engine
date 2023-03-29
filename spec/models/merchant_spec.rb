require "rails_helper"

RSpec.describe Merchant do 
  describe "validations" do 
    it {should validate_presence_of :name}
  end

  describe "relationships" do 
    it {should have_many :items}
    it {should have_many :invoices}
  end

  describe "find_by_name_query" do 
    it "can find the merchant by a name fragment" do 
      merchant_1 = create(:merchant, name: "Awesome Pizza")
      merchant_2 = create(:merchant, name: "Vintage Mirrors")

      expect(Merchant.find_by_name_query("Awesome")).to eq(merchant_1)
      expect(Merchant.find_by_name_query("Awe")).to eq(merchant_1)
      expect(Merchant.find_by_name_query("Pizza")).to eq(merchant_1)
      expect(Merchant.find_by_name_query("za")).to eq(merchant_1)
      expect(Merchant.find_by_name_query("Awesesom")).to_not eq(merchant_2)
    end

    it "returns the first name in alphabetical order if more than one result is found" do 
      merchant_1 = create(:merchant, name: "Awesome Pizza")
      merchant_2 = create(:merchant, name: "Vintage Mirrors")
      merchant_3 = create(:merchant, name: "Turing")
      merchant_4 = create(:merchant, name: "Ring World")
      

      expect(Merchant.find_by_name_query("ring")).to eq(merchant_4)
    end
  end
end