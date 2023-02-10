class ItemNegativePriceError < StandardError
  def message
    "Price cannot be negative"
  end
end