class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.find_first_merchant(name)
    search(name).order(:name).first
  end

  def self.search(name)
    where("name ILIKE ?", "%#{name}%")
  end
end