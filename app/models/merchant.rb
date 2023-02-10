class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.search(params)
    check_params(passed_params(params))
    find_first_merchant(params[:name])
  end

  def self.find_first_merchant(name)
    merchant = search_by_name(name).order(:name).first
    raise MerchantNotFoundError if merchant.nil?
    merchant
  end

  def self.search_by_name(name)
    where("name ILIKE ?", "%#{name}%")
  end

  def self.check_params(params)
    if params.empty?
      raise MissingParamsError
    elsif other_params?(params)
      raise MerchantParamsError
    elsif params[:name].empty?
      raise EmptyParamsError
    end
  end

  def self.other_params?(params)
    (params.keys - supported_params).any?
  end

  def self.supported_params
    ["name"]
  end
end