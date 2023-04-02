class Invoice < ApplicationRecord 
  belongs_to :merchant
  belongs_to :customer
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items 
  has_many :transactions

  validates_presence_of :status

  def self.only_one_item 
    Invoice.joins(:items).group('invoices.id').having('count(invoice_items.invoice_id) = 1')
  end
end