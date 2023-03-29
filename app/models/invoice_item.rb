class InvoiceItem < ApplicationRecord 
  belongs_to :invoice
  belongs_to :item

  validates_numericality_of :unit_price, :quantity
  validates_presence_of :unit_price, :quantity
end