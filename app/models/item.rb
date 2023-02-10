class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  def self.get_items_by_page(params)
    page = params.fetch(:page, 1).to_i
    per_page = params.fetch(:per_page, 20).to_i

    offset((page-1)*per_page).limit(per_page)
  end

  def self.search_all(params)
    check_params(passed_params(params))
    find_all_items(params)
  end

  def self.find_all_items(params)
    if params[:name]
      items = search_by_name(params[:name]) 
    else
      items = search_by_price(params[:min_price], params[:max_price])
    end

    raise ItemNotFoundError if items.empty?

    items
  end

  def self.search_by_name(name)
    where("name ILIKE ?", "%#{name}%")
  end

  def self.search_by_price(min_price = nil, max_price = nil)
    min_price ||= 0
    max_price ||= Item.maximum(:unit_price)

    where(unit_price: min_price.to_f..max_price.to_f)
  end

  def self.check_params(params)
    if missing_params?(params)
      raise MissingParamsError
    elsif other_params?(params)
      raise ItemParamsError
    elsif empty_params?(params)
      raise EmptyParamsError
    elsif mixed_params?(params)
      raise ItemMixedParamsError
    elsif negative_price?(params)
      raise ItemNegativePriceError
    end
  end

  def self.negative_price?(params)
    (params[:min_price].to_f.negative? if params[:min_price]) ||
      (params[:max_price].to_f.negative? if params[:max_price])
  end

  def self.missing_params?(params)
    params.empty?
  end

  def self.other_params?(params)
    (params.keys - valid_params).any?
  end

  def self.empty_params?(params)
    passed_valid_params = params.keys & valid_params
    passed_valid_params.any? do |key|
      params[key].empty?
    end
  end

  def self.mixed_params?(params)
    params[:name] && (params[:min_price] || params[:max_price])
  end

  def self.valid_params
    ["name", "min_price", "max_price"]
  end
end
