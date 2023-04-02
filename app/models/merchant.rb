class Merchant < ApplicationRecord
  has_many :items 
  has_many :invoices

  has_many :invoice_items, through: :invoices 
  has_many :customers, through: :invoices 
  has_many :transactions, through: :invoices

  validates_presence_of :name

  def self.find_by_name_query(name_fragment)
    where("lower(name) ILIKE?", "%#{name_fragment}%").order(:name).first
  end
end