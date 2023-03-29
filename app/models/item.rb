class Item < ApplicationRecord 
  belongs_to :merchant 

  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price


  def self.find_by_name_search(name_fragment)
    where("lower(name) ILIKE?", "%#{name_fragment}%").order(:name)
  end

  def self.find_by_min_price(number)
    where('unit_price >= ?', number.to_f).order(:name)
  end

  def self.find_by_max_price(number)
    where('unit_price <= ?', number.to_f).order(:name)
  end

  def self.find_by_price_between(max, min)
    where('unit_price <= ?', max.to_f).where('unit_price >= ?', min.to_f).order(:name)
  end
end