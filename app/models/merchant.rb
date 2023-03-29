class Merchant < ApplicationRecord
  has_many :items 

  validates_presence_of :name

  def self.find_by_name_query(name_fragment)
    where("lower(name) ILIKE?", "%#{name_fragment}%").order(:name).first
  end
end